import os
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter as report_letter
from reportlab.lib.units import inch

def create_bubble_sheet(filename, num_questions=20, title=None):
    """
    Create a bubble sheet template PDF with the specified number of questions.
    """
    c = canvas.Canvas(filename, pagesize=report_letter)
    width, height = report_letter

    # Set default title if not specified
    if title is None:
        title = f"MattChecker {num_questions}-Question Answer Sheet"

    # Configuration based on number of questions
    if num_questions <= 20:
        columns_per_page = 1
        questions_per_column = 20
    elif num_questions <= 50:
        columns_per_page = 2
        questions_per_column = 25
    else:  # 100 questions
        columns_per_page = 4
        questions_per_column = 25

    # Draw header
    c.setFont("Helvetica-Bold", 16)
    c.drawCentredString(width/2, height - 0.75*inch, title)
    c.setFont("Helvetica", 12)
    c.drawCentredString(width/2, height - 1.1*inch, "Fill in the bubble corresponding to your answer for each question")
    c.setFont("Helvetica-Bold", 12)
    c.drawString(1*inch, height - 1.5*inch, "Name: ________________________________")
    c.drawString(width - 4*inch, height - 1.5*inch, "ID: ___________________")

    start_y = height - 2.2*inch
    column_width = (width - 2*inch) / columns_per_page
    spacing = 0.3*inch if num_questions <= 20 else 0.25*inch

    current_question = 1
    for col in range(columns_per_page):
        col_x = 1.0*inch + col * column_width

        for i in range(questions_per_column):
            if current_question > num_questions:
                break

            y = start_y - (i * spacing)

            c.setFont("Helvetica-Bold", 10)
            c.drawString(col_x, y, f"{current_question}.")

            bubble_x = col_x + 0.25*inch
            c.setFont("Helvetica", 8)
            for j, letter in enumerate(['A', 'B', 'C', 'D']):
                c.circle(bubble_x + j*0.25*inch, y, 4, stroke=1, fill=0)
                c.drawString(bubble_x + j*0.25*inch - 2, y - 2, letter)

            current_question += 1

    c.save()
    print(f"Created {filename} with {num_questions} questions")

def main():
    output_dir = "static/templates"
    os.makedirs(output_dir, exist_ok=True)

    create_bubble_sheet(f"{output_dir}/standard_20.pdf", 20, "Standard 20-Question Answer Sheet")
    create_bubble_sheet(f"{output_dir}/extended_50.pdf", 50, "Extended 50-Question Answer Sheet")
    create_bubble_sheet(f"{output_dir}/comprehensive_100.pdf", 100, "Comprehensive 100-Question Answer Sheet")

if __name__ == "__main__":
    main()