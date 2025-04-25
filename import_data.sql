-- Clear existing data
DELETE FROM answer;
DELETE FROM scan_result;
DELETE FROM question;
DELETE FROM student;

-- Insert questions with correct answers (A, B, C, D, E in rotation)
-- First the standard 20 questions
INSERT INTO question (question_id, correct_answer) VALUES
(1, 'A'), (2, 'B'), (3, 'C'), (4, 'D'), (5, 'E'),
(6, 'A'), (7, 'B'), (8, 'C'), (9, 'D'), (10, 'E'),
(11, 'A'), (12, 'B'), (13, 'C'), (14, 'D'), (15, 'E'),
(16, 'A'), (17, 'B'), (18, 'C'), (19, 'D'), (20, 'E');

-- Add questions 21-50 for extended templates
INSERT INTO question (question_id, correct_answer) VALUES
(21, 'A'), (22, 'B'), (23, 'C'), (24, 'D'), (25, 'E'),
(26, 'A'), (27, 'B'), (28, 'C'), (29, 'D'), (30, 'E'),
(31, 'A'), (32, 'B'), (33, 'C'), (34, 'D'), (35, 'E'),
(36, 'A'), (37, 'B'), (38, 'C'), (39, 'D'), (40, 'E'),
(41, 'A'), (42, 'B'), (43, 'C'), (44, 'D'), (45, 'E'),
(46, 'A'), (47, 'B'), (48, 'C'), (49, 'D'), (50, 'E');

-- Add questions 51-100 for comprehensive templates
INSERT INTO question (question_id, correct_answer) VALUES
(51, 'A'), (52, 'B'), (53, 'C'), (54, 'D'), (55, 'E'),
(56, 'A'), (57, 'B'), (58, 'C'), (59, 'D'), (60, 'E'),
(61, 'A'), (62, 'B'), (63, 'C'), (64, 'D'), (65, 'E'),
(66, 'A'), (67, 'B'), (68, 'C'), (69, 'D'), (70, 'E'),
(71, 'A'), (72, 'B'), (73, 'C'), (74, 'D'), (75, 'E'),
(76, 'A'), (77, 'B'), (78, 'C'), (79, 'D'), (80, 'E'),
(81, 'A'), (82, 'B'), (83, 'C'), (84, 'D'), (85, 'E'),
(86, 'A'), (87, 'B'), (88, 'C'), (89, 'D'), (90, 'E'),
(91, 'A'), (92, 'B'), (93, 'C'), (94, 'D'), (95, 'E'),
(96, 'A'), (97, 'B'), (98, 'C'), (99, 'D'), (100, 'E');

-- Insert actual student data from the checker_db user_info table
INSERT INTO student (name, student_id) VALUES
('ADALID, JOHN SIMON DIAZ', '20220003'),
('LEYNES, CHRISTOPHER FIESTA', '20220007'),
('DOMINGO, GABRIEL CUBALAN', '20220012'),
('VERGARA, JOVIN LEE', '20220026'),
('CASTRO, KURT LOUIE CASTRO', '20220027'),
('DAVAC, VINCENT AHRON MANTUHAC', '20220041'),
('CHAN, IAN MYRON LUNA', '20220060'),
('CRUZ, DANIKEN SANTOS', '20220078'),
('COLENDRES, SHERWIN BONIFACIO', '20220081'),
('BIAGTAS, ALTHEA NICOLE LAGUNA', '20220085'),
('VINLUAN, AILA RAMOS', '20220086'),
('BAENA, VINCE IVERSON CAMACHO', '20220111'),
('PUNO, LOURINE ASHANTI MATEL', '20220112'),
('URETA, JAN EDMAINE DELA TORRE', '20220129'),
('MANGALINDAN, JEROME TAMAYO', '20220152'),
('COMPETENTE, ANNENA CAMBI', '19110182'),
('DELOS REYES, AARON VINCENT MANLAPAZ', '20190994'),
('CUADERNO, NICOLE MAYA', '20201202'),
('BARCENA, DIVINE GRACE DAWAL', '20210004'),
('ANZA, AIRA JOYCE NAVARRO', '20211490');