import os
import random
import traceback
import cv2
import numpy as np
import pytesseract
import Levenshtein
from datetime import datetime
import uuid
from pdf2image import convert_from_path
from PIL import Image
from flask import current_app
from models import Student, db

class BubbleSheetScanner:
    """
    A simplified bubble sheet scanner that operates in demo mode without requiring 
    OpenCV or other image processing libraries.
    """
    def __init__(self):
        # Map the template names from the UI to internal template configurations
        self.templates = {
            # 20-question templates
            'standard_20': {
                'identifier': 'Standard 20-Question Template',
                'questions_per_sheet': 20,
                'choices': ['A', 'B', 'C', 'D', 'E']
            },
            # 50-question templates
            'extended_50': {
                'identifier': 'Extended 50-Question Template',
                'questions_per_sheet': 50,
                'choices': ['A', 'B', 'C', 'D', 'E']
            },
            # 100-question templates
            'comprehensive_100': {
                'identifier': 'Comprehensive 100-Question Template',
                'questions_per_sheet': 100,
                'choices': ['A', 'B', 'C', 'D', 'E']
            },
            # Legacy templates (keeping for backward compatibility)
            'template1_20': {
                'identifier': 'EXAM ANSWER SHEET - 20Q',
                'questions_per_sheet': 20,
                'choices': ['A', 'B', 'C', 'D', 'E']
            },
            'template2_20': {
                'identifier': '# EXAM ANSWER SHEET - 20Q',
                'questions_per_sheet': 20,
                'choices': ['A', 'B', 'C', 'D', 'E']
            }
        }
        self.current_template = None

    def get_correct_answers(self, question_count=None):
        """Get correct answers from the database, or generate demo answers with the specified question count."""
        try:
            from app import db
            from sqlalchemy import text

            # Attempt to fetch from database
            with db.engine.connect() as conn:
                # Check how many questions are in the database
                count_result = conn.execute(text("SELECT COUNT(*) FROM question"))
                count = count_result.fetchone()[0]

                # If we need more questions than exist in the database, we need to extend
                if question_count and question_count > count:
                    print(f"Extending answers from {count} to {question_count} questions")
                    # First get existing answers
                    result = conn.execute(text("SELECT question_id, correct_answer FROM question ORDER BY question_id"))
                    answers = {str(row[0]): row[1] for row in result}

                    # Generate additional answers in a pattern (A, B, C, D, E repeat)
                    choices = ['A', 'B', 'C', 'D', 'E']
                    for i in range(count + 1, question_count + 1):
                        answers[str(i)] = choices[(i - 1) % 5]

                    return answers
                else:
                    # If question_count is specified and we have enough questions, limit the number
                    if question_count:
                        result = conn.execute(text("SELECT question_id, correct_answer FROM question WHERE question_id <= :limit ORDER BY question_id"), 
                                             {"limit": question_count})
                    else:
                        result = conn.execute(text("SELECT question_id, correct_answer FROM question ORDER BY question_id"))

                    answers = {str(row[0]): row[1] for row in result}

                    if not answers:
                        # If no answers in database, return demo answers
                        answers = self._get_demo_answers(question_count or 20)

                    return answers
        except Exception as e:
            print(f"Database error: {e}")
            # Fall back to demo answers
            return self._get_demo_answers(question_count or 20)

    def _get_demo_answers(self, question_count=20):
        """Generate demo answers for testing with the specified number of questions."""
        choices = ['A', 'B', 'C', 'D', 'E']
        return {str(i): choices[i % 5] for i in range(1, question_count + 1)}

    def process_sheet(self, image_path):
        """
        Process the uploaded sheet using OCR and image processing techniques.
        Falls back to demo mode if image processing fails.
        """
        try:
            # Check if image exists
            if not os.path.exists(image_path):
                return None, "Could not read image"

            # Use the current_template if set, otherwise randomly select a template
            if not self.current_template or self.current_template not in self.templates:
                template_name = random.choice(list(self.templates.keys()))
                self.current_template = template_name
            else:
                template_name = self.current_template

            template = self.templates[template_name]

            # Get question count from the template
            question_count = template['questions_per_sheet']

            # Get correct answers from the database based on the template's question count
            correct_answers = self.get_correct_answers(question_count)

            # Try to extract student info using OCR
            ocr_student_info = self.extract_student_info_from_image(image_path)

            # Validate that we have a proper examination sheet
            # Check if we found any student info or if we captured any identifiable text
            if not ocr_student_info or (not ocr_student_info.get('name') and not ocr_student_info.get('id')):
                print("OCR failed to extract student info")
                return None, "No valid examination sheet detected. Please ensure the sheet is clearly visible and well-lit."

            # Check if what we captured is actually just the title of the sheet and not a student name
            name_lower = ocr_student_info.get('name', '').lower()
            if 'exam' in name_lower and 'sheet' in name_lower or 'answer' in name_lower and 'sheet' in name_lower:
                print("OCR detected only the title of the sheet, not a valid student name")
                return None, "No student information detected. Please make sure the student name and ID are clearly visible at the top of the sheet."

            student_info = ocr_student_info
            print(f"OCR extracted student info: {student_info}")

            # Try to match student with database
            matched_student = self._match_student_with_database(student_info)
            if matched_student:
                student_info = matched_student
                print(f"Matched with student in database: {student_info['name']} (ID: {student_info['id']})")

            # Check if this is actually a bubble sheet by looking for bubbles
            has_bubbles = self._check_for_bubbles(image_path)
            if not has_bubbles:
                print("No bubbles detected in the image")
                return None, "No bubble answer sheet detected. Please make sure you're capturing an actual MattChecker examination sheet."

            # Process the bubbles to get actual answers from the sheet
            print("Processing answer bubbles...")
            answers = self._process_answer_bubbles(image_path, question_count, template_name)

            # Calculate score by comparing with correct answers
            score = 0
            for q_num, selected in answers.items():
                if q_num in correct_answers and selected == correct_answers[q_num]:
                    score += 1

            # Debug logging
            print(f"Processing sheet for student: {student_info['name']} (ID: {student_info['id']})")
            print(f"Using template: {template_name} with {question_count} questions")

            # Reset current_template after processing to ensure we don't reuse it unexpectedly
            reset_template = self.current_template
            self.current_template = None

            return {
                'success': True,
                'template': reset_template,
                'template_info': template,
                'student': student_info,
                'score': {
                    'correct': score,
                    'total': len(correct_answers),
                    'percentage': round(score / len(correct_answers) * 100, 1) if len(correct_answers) > 0 else 0
                },
                'answers': answers,
                'correct_answers': correct_answers
            }, None
        except Exception as e:
            print(f"Error processing sheet: {e}")
            traceback.print_exc()
            return None, "Error processing image. Please make sure you are capturing a valid examination sheet with clear student information."

    def _generate_demo_student_info(self):
        """Get a random student from the database using the user_info table."""
        try:
            from app import db
            from sqlalchemy import text

            # Use user_info table directly instead of student table
            with db.engine.connect() as conn:
                result = conn.execute(text("""
                    SELECT member_id, name 
                    FROM user_info 
                    WHERE role = 'student' 
                    ORDER BY RANDOM() 
                    LIMIT 1"""))
                student = result.fetchone()

                if student:
                    return {
                        'name': student[1],
                        'id': str(student[0])
                    }
                else:
                    print("No students found in the user_info table")
                    return {
                        'name': "No students found in database",
                        'id': "ERROR"
                    }
        except Exception as e:
            print(f"Database error when fetching student: {e}")
            traceback.print_exc()

        # Fallback if database query fails or returns no results
        # This should only happen if there's a database connection issue
        fallback_student = {
            'name': "DATABASE ERROR - Please setup student data",
            'id': "ERROR"
        }

        return fallback_student

    def _generate_demo_answers(self, correct_answers):
        """Generate demo answers with reasonable accuracy."""
        answers = {}
        # Determine accuracy level (70-95%)
        accuracy = random.uniform(0.70, 0.95)
        score = 0

        for q_num, correct in correct_answers.items():
            # Determine if this answer will be correct
            if random.random() < accuracy:
                # Give correct answer
                answers[q_num] = correct
                score += 1
            else:
                # Give wrong answer or occasionally no answer
                if random.random() < 0.1:  # 10% chance of no answer
                    answers[q_num] = None
                else:
                    choices = ['A', 'B', 'C', 'D', 'E']
                    if correct in choices:
                        choices.remove(correct)
                    answers[q_num] = random.choice(choices)

        return answers, score

    def extract_student_info_from_image(self, image_path):
        """
        Use OCR to extract student information from the scanned image.
        Returns a dictionary with name and ID.
        """
        try:
            # Load the image
            img = cv2.imread(image_path)
            if img is None:
                print(f"Failed to load image: {image_path}")
                return None

            # Convert to grayscale
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            # Get image dimensions
            height, width = gray.shape

            # Enhance image contrast
            gray = cv2.equalizeHist(gray)
            
            # Apply adaptive thresholding
            binary = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                         cv2.THRESH_BINARY, 11, 2)

            # Define the region of interest (ROI) for student info - expanded area
            roi_top = int(height * 0.01)  # 1% from top
            roi_height = int(height * 0.25)  # 25% of image height
            roi_student_info = binary[roi_top:roi_top+roi_height, 0:width]

            # Apply additional preprocessing to improve text detection
            roi_student_info = cv2.GaussianBlur(roi_student_info, (3, 3), 0)
            roi_student_info = cv2.adaptiveThreshold(
                roi_student_info, 
                255,
                cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
                cv2.THRESH_BINARY,
                11,
                2
            )

            # Denoise the ROI
            roi_student_info = cv2.fastNlMeansDenoising(roi_student_info)
            _, threshold = cv2.threshold(roi_student_info, 150, 255, cv2.THRESH_BINARY_INV)

            # Apply noise reduction
            kernel = np.ones((1, 1), np.uint8)
            threshold = cv2.dilate(threshold, kernel, iterations=1)
            threshold = cv2.erode(threshold, kernel, iterations=1)

            # Invert back to black text on white background for OCR
            threshold = cv2.bitwise_not(threshold)

            # Save the processed ROI to a temporary file
            from flask import current_app
            temp_roi_path = os.path.join(
                current_app.config['UPLOAD_FOLDER'],
                f"temp_student_roi_{uuid.uuid4().hex}.png"
            )
            cv2.imwrite(temp_roi_path, threshold)

            # Perform OCR on the processed image
            # Adjust these parameters based on your testing
            custom_config = r'--oem 3 --psm 6'
            ocr_text = pytesseract.image_to_string(Image.open(temp_roi_path), config=custom_config)

            # Clean up the temporary file
            os.remove(temp_roi_path)

            # Process the OCR text to extract student info
            student_info = self._parse_student_info(ocr_text)

            # Match the extracted info with student database for better accuracy
            student_info = self._match_student_with_database(student_info)

            return student_info

        except Exception as e:
            print(f"Error extracting student info from image: {e}")
            traceback.print_exc()
            return None

    def _parse_student_info(self, ocr_text):
        """
        Parse the OCR text to extract student name and ID.
        Uses strict validation to ensure we have legitimate student information.
        """
        lines = ocr_text.split('\n')
        student_name = ""
        student_id = ""

        # Look for patterns that might indicate student information
        for line in lines:
            line = line.strip()
            if not line:
                continue

            # Look for student ID (typically a number with 8 digits)
            id_candidates = [word for word in line.split() if word.isdigit() and 5 <= len(word) <= 10]
            if id_candidates:
                student_id = id_candidates[0]

            # Look for student name using strict criteria
            # Must have at least 2 words and be reasonably long
            words = line.split()
            if len(words) >= 2 and len(line) >= 8:
                # Check if it has a comma (LASTNAME, FIRSTNAME format) or is all caps
                if "," in line and any(c.isupper() for c in line):
                    student_name = line
                # Or if it has a recognizable name pattern with mostly alphabetic characters
                elif sum(c.isalpha() for c in line) / len(line) > 0.7:  # At least 70% letters
                    student_name = line

        # Additional validation - reject random strings and symbols 
        if student_name and (sum(c in ".,;:()-_+=*&^%$#@!<>?/\\|" for c in student_name) / len(student_name) > 0.3):
            # Too many special characters, probably not a name
            student_name = ""

        # Minimum length check for student name
        if len(student_name) < 5:
            student_name = ""

        return {
            'name': student_name,
            'id': student_id
        }

    def _match_student_with_database(self, student_info):
        """
        Match the extracted student information with database records.
        Uses fuzzy matching for better accuracy.
        """
        if not student_info or (not student_info['name'] and not student_info['id']):
            return student_info  # Return the original info, don't fall back to demo data

        try:
            # If we have a student ID, try to match by ID first
            if student_info['id']:
                student = Student.query.filter_by(student_id=student_info['id']).first()
                if student:
                    return {
                        'name': student.name,
                        'id': student.student_id
                    }

            # If no ID match or no ID provided, try fuzzy matching with names
            if student_info['name']:
                # Get all students from the database
                students = Student.query.all()

                best_match = None
                best_score = 0

                for student in students:
                    # Calculate Levenshtein distance (smaller = more similar)
                    distance = Levenshtein.distance(student_info['name'].upper(), student.name.upper())

                    # Convert distance to a similarity score (higher = more similar)
                    # The max function ensures we don't divide by zero
                    max_len = max(len(student_info['name']), len(student.name))
                    if max_len == 0:
                        continue

                    similarity = 1.0 - (distance / max_len)

                    # If this is the best match so far, store it
                    if similarity > best_score and similarity > 0.6:  # 60% similarity threshold
                        best_score = similarity
                        best_match = student

                if best_match:
                    return {
                        'name': best_match.name,
                        'id': best_match.student_id
                    }

        except Exception as e:
            print(f"Error matching student with database: {e}")
            traceback.print_exc()

        # Always return the original student info if available, never fallback to demo
        return student_info

    def _check_for_bubbles(self, image_path):
        """
        Check if an image contains bubble answer sheet patterns (circles/bubbles).
        Returns True if bubbles are detected, False otherwise.
        """
        try:
            # Load the image
            img = cv2.imread(image_path)
            if img is None:
                return False

            # Convert to grayscale
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            # Apply some blur to reduce noise
            blurred = cv2.GaussianBlur(gray, (5, 5), 0)

            # Apply threshold
            _, thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)

            # Find contours
            contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

            # Filter contours that look like circles (bubbles)
            bubble_candidates = 0
            for contour in contours:
                # Calculate area and perimeter
                area = cv2.contourArea(contour)
                perimeter = cv2.arcLength(contour, True)

                # Skip very small contours
                if area < 100:
                    continue

                # Calculate circularity: 4*pi*area/perimeter^2
                # A perfect circle has a circularity of 1
                if perimeter > 0:
                    circularity = 4 * np.pi * area / (perimeter * perimeter)

                    # If circularity is close to 1, it's likely a circle
                    if 0.5 < circularity < 1.5:  # More lenient circularity check
                        bubble_candidates += 1

            # If we found enough circles, this is likely a bubble sheet
            # Lower threshold and improve detection
            print(f"Found {bubble_candidates} bubble candidates")
            return bubble_candidates >= 5 # Lower threshold for better detection

        except Exception as e:
            print(f"Error checking for bubbles: {e}")
            traceback.print_exc()
            return False

    def _process_answer_bubbles(self, image_path, question_count, template_name):
        """
        Process the bubble answer sheet to detect which bubbles are filled in.
        Returns a dictionary mapping question numbers to selected answers.
        """
        try:
            # Load the image
            img = cv2.imread(image_path)
            if img is None:
                print(f"Failed to load image for bubble processing: {image_path}")
                return {}

            # Convert to grayscale
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

            # Apply adaptive thresholding
            thresh = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, 
                                         cv2.THRESH_BINARY_INV, 11, 2)

            # Defining answer regions based on the template
            # These values need to be adjusted based on actual template
            template_config = self._get_template_regions(template_name, question_count, img.shape[0], img.shape[1])

            # Dictionary to store answers
            answers = {}

            # Process each question
            for question_num in range(1, question_count + 1):
                q_str = str(question_num)

                # Get the region for this question
                region = self._get_question_region(question_num, template_config)
                if not region:
                    print(f"Cannot locate region for question {question_num}")
                    answers[q_str] = None
                    continue

                # Extract the region of interest (ROI) for this question
                y1, y2, x1, x2 = region
                roi = thresh[y1:y2, x1:x2]

                if roi.size == 0:
                    print(f"Empty ROI for question {question_num}")
                    answers[q_str] = None
                    continue

                # Find the filled bubble for this question
                selected_option, visualization = self._find_filled_bubble(roi)
                answers[q_str] = selected_option

                # Debug - save the ROI for inspection
                if question_num <= 5:  # Only save first few for debugging
                    from flask import current_app
                    debug_path = os.path.join(
                        current_app.config['UPLOAD_FOLDER'],
                        f"debug_q{question_num}_{uuid.uuid4().hex}.png"
                    )
                    cv2.imwrite(debug_path, visualization if visualization is not None else roi)

            return answers

        except Exception as e:
            print(f"Error processing answer bubbles: {e}")
            traceback.print_exc()
            return {}

    def _get_template_regions(self, template_name, question_count, img_height, img_width):
        """
        Define the regions for each question based on the template.
        Returns a configuration dictionary with region parameters.
        """
        # Default configuration
        config = {
            'answer_region_top': int(img_height * 0.25),  # Start after student info
            'answer_region_height': int(img_height * 0.7),  # Most of the remaining page
            'answer_region_left': int(img_width * 0.1),
            'answer_region_width': int(img_width * 0.8),
            'bubbles_per_row': 4,  # A, B, C, D
            'option_labels': ['A', 'B', 'C', 'D'],
            'questions_per_page': 20,
            'question_height': 0,  # Will be calculated
            'question_spacing': 10,  # Space between questions
            'option_width': 0,  # Will be calculated
            'current_page': 0  # First page
        }

        # Adjust based on template
        if template_name == 'standard_20':
            config['questions_per_page'] = 20
        elif template_name == 'extended_50':
            config['questions_per_page'] = 25  # 25 questions per page, 2 pages
        elif template_name == 'comprehensive_100':
            config['questions_per_page'] = 25  # 25 questions per page, 4 pages

        # Calculate question height based on available space and question count
        questions_on_current_page = min(config['questions_per_page'], question_count)
        total_spacing = config['question_spacing'] * (questions_on_current_page - 1)
        config['question_height'] = (config['answer_region_height'] - total_spacing) / questions_on_current_page

        # Calculate option width
        config['option_width'] = config['answer_region_width'] / config['bubbles_per_row']

        return config

    def _get_question_region(self, question_num, config):
        """
        Calculate the region for a specific question.
        Returns (y1, y2, x1, x2) coordinates for the question's bubble area.
        """
        # Determine which page this question is on
        page = (question_num - 1) // config['questions_per_page']

        # If the current page doesn't match the question's page, we can't process it
        # (This would require multi-page processing, which is more complex)
        if page != config['current_page']:
            return None

        # Adjust question_num to be relative to the current page
        relative_q_num = ((question_num - 1) % config['questions_per_page']) + 1

        # Calculate the top position of this question
        q_top = config['answer_region_top'] + (relative_q_num - 1) * (config['question_height'] + config['question_spacing'])

        # Define the region
        y1 = int(q_top)
        y2 = int(q_top + config['question_height'])
        x1 = int(config['answer_region_left'])
        x2 = int(config['answer_region_left'] + config['answer_region_width'])

        return (y1, y2, x1, x2)

    def _find_filled_bubble(self, roi):
        """
        Find which bubble is filled using OMR techniques.
        Returns the letter (A, B, C, D, E) of the selected option and a visualization,
        or (None, None) if none is detected.
        """
        # Apply OMR-specific preprocessing
        blurred = cv2.GaussianBlur(roi, (5, 5), 0)
        thresh = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
        
        # Create visualization
        viz = cv2.cvtColor(roi, cv2.COLOR_GRAY2BGR)

        # Divide the ROI into 5 equal parts for the 5 options (A-E)
        num_options = 5
        option_width = roi.shape[1] // num_options
        option_labels = ['A', 'B', 'C', 'D', 'E']

        max_filled = 0
        selected_option = None
        selected_region = None

        # Draw vertical lines to show the option divisions
        for i in range(1, num_options):
            x = i * option_width
            cv2.line(viz, (x, 0), (x, roi.shape[0]), (0, 255, 0), 1)

            # Add option labels
            label_x = (i - 0.5) * option_width
            cv2.putText(viz, option_labels[i-1], (int(label_x), 20), 
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1)

        # Add the last label
        last_label_x = (num_options - 0.5) * option_width
        cv2.putText(viz, option_labels[num_options-1], (int(last_label_x), 20), 
                    cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 255), 1)

        # Analyze each option
        for i in range(num_options):
            # Extract the region for this option
            x1 = i * option_width
            x2 = (i + 1) * option_width
            option_roi = roi[:, x1:x2]

            # Apply OMR detection
            option_thresh = cv2.threshold(option_roi, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]
            filled_pixels = cv2.countNonZero(option_thresh)
            
            # Calculate fill percentage for more accurate detection
            fill_percentage = (filled_pixels / option_roi.size) * 100
            fill_text = f"{fill_percentage:.1f}%"
            
            # Use percentage threshold for better accuracy
            if fill_percentage > 30:  # Adjust threshold as needed
                contours = cv2.findContours(option_thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[0]
                if contours:
                    # Analyze contour shape for more accurate bubble detection
                    largest_contour = max(contours, key=cv2.contourArea)
                    if cv2.contourArea(largest_contour) > 100:
                        filled_pixels = int(fill_percentage * 10)  # Weight by fill percentage
            cv2.putText(viz, fill_text, (x1 + 5, roi.shape[0] - 10), 
                        cv2.FONT_HERSHEY_SIMPLEX, 0.4, (255, 0, 0), 1)

            # If this is the most filled option so far, select it
            # Only select if it has a significant number of filled pixels
            if filled_pixels > max_filled and filled_pixels > 50:  # Threshold to avoid noise
                max_filled = filled_pixels
                selected_option = option_labels[i]
                selected_region = (x1, x2)

        # Highlight the selected option
        if selected_region:
            cv2.rectangle(viz, (selected_region[0], 0), (selected_region[1], roi.shape[0]), 
                         (0, 255, 255), 2)
            # Add text to show which option was detected
            cv2.putText(viz, f"SELECTED: {selected_option}", (10, roi.shape[0] - 30), 
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 1)

        return selected_option, viz

    def convert_pdf_to_images(self, pdf_path):
        """
        Convert a PDF file to images using pdf2image.
        """
        try:
            # Create a directory for storing converted images if it doesn't exist
            os.makedirs(current_app.config['UPLOAD_FOLDER'], exist_ok=True)

            # Convert PDF to images
            images = convert_from_path(pdf_path)

            image_paths = []
            for i, image in enumerate(images):
                # Save the image
                image_path = os.path.join(
                    current_app.config['UPLOAD_FOLDER'],
                    f"page_{i}_{datetime.now().strftime('%Y%m%d%H%M%S')}.png"
                )
                image.save(image_path, 'PNG')
                image_paths.append(image_path)

            return image_paths
        except Exception as e:
            print(f"Error converting PDF to images: {e}")
            traceback.print_exc()

            # Fallback to the old method if conversion fails
            image_path = os.path.join(
                current_app.config['UPLOAD_FOLDER'],
                f"page_0_{datetime.now().strftime('%Y%m%d%H%M%S')}.png"
            )

            # Just copy the file with a new name for demonstration
            with open(pdf_path, 'rb') as pdf_file:
                with open(image_path, 'wb') as image_file:
                    image_file.write(pdf_file.read())

            return [image_path]