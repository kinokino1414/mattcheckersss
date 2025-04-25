-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 08, 2025 at 07:12 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `checker_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `classes`
--

CREATE TABLE `classes` (
  `class_id` int(11) NOT NULL,
  `class_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `member_id` int(11) NOT NULL,
  `class_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `classes`
--

INSERT INTO `classes` (`class_id`, `class_name`, `created_at`, `member_id`, `class_code`) VALUES
(7, 'CSS 112', '2025-03-19 18:39:05', 20220168, '8e3fcf'),
(8, 'IAS 1', '2025-03-19 19:01:17', 20220168, 'b7e772'),
(11, 'system adminis', '2025-03-21 07:25:17', 20220168, '777f6f'),
(14, 'BSIT A', '2025-03-26 23:51:42', 20220168, 'f08601'),
(15, 'BSIT-3B', '2025-03-28 18:23:12', 20220168, 'a82be6'),
(16, 'IT Elective', '2025-03-29 09:27:24', 20220168, '07c8e4');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `token` varchar(100) NOT NULL,
  `expires_at` datetime NOT NULL,
  `reset_code` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `quiz_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `instructions` text DEFAULT NULL,
  `quiz_type` enum('multiple_choice','short_answer') NOT NULL,
  `time_limit` time DEFAULT '00:30:00',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `class_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`quiz_id`, `member_id`, `title`, `instructions`, `quiz_type`, `time_limit`, `created_at`, `class_id`) VALUES
(98, 20220168, 'Sample Quiz 3 - Identification', 'Identification instruction.', 'short_answer', '00:30:00', '2025-03-23 17:08:46', 7),
(99, 20220168, 'Sample Quiz 2 - Multiple Choice', 'Multiple Choice instructions.', 'multiple_choice', '00:30:00', '2025-03-23 17:09:21', 7),
(100, 20220168, 'Sample Quiz 3 - True or False', 'True or False instruction.', '', '00:30:00', '2025-03-23 17:09:53', 7),
(101, 20220168, 'Sample Quiz 3 - Short &#039;n Sweet', 'Instructions.', 'short_answer', '00:30:00', '2025-03-23 17:13:03', 7),
(102, 20220168, 'Sample Quiz 3 - Short &#039;n Sweet', 'True or False instructions.', '', '00:30:00', '2025-03-23 17:40:31', 7),
(103, 20220168, 'Sample Quiz 1 - identification', 'identification instruction', 'short_answer', '00:30:00', '2025-03-29 09:30:05', 16),
(104, 20220168, 'Quiz 2', 'ALL CAPS', 'multiple_choice', '00:30:00', '2025-03-29 09:32:17', 7),
(105, 20220168, 'Sample Quiz - Multiple Choice', 'Multiple Choice', 'multiple_choice', '00:30:00', '2025-03-29 09:36:17', 16),
(106, 20220168, 'trues false', 'trusfa sle', '', '00:30:00', '2025-04-02 13:54:02', 16),
(107, 20220168, 'trus2', 'sadas', '', '00:30:00', '2025-04-02 14:06:07', 16),
(108, 20220168, 'trus3', 'dsfsdf', '', '00:30:00', '2025-04-02 14:11:35', 16),
(111, 20220168, 'trus7', 'dsfdsf', '', '00:30:00', '2025-04-02 15:41:50', 16),
(115, 20220168, 'sfsdf', 'zxcvxv', '', '00:30:00', '2025-04-02 16:14:21', 16);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_answers`
--

CREATE TABLE `quiz_answers` (
  `answer_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `correct_answer` int(11) DEFAULT NULL,
  `correct_answer_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_answers`
--

INSERT INTO `quiz_answers` (`answer_id`, `question_id`, `correct_answer`, `correct_answer_text`) VALUES
(69, 601, NULL, 'Paolo'),
(70, 604, NULL, 'Paolo'),
(71, 606, NULL, 'Answer');

-- --------------------------------------------------------

--
-- Table structure for table `quiz_choices`
--

CREATE TABLE `quiz_choices` (
  `choice_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `choice_text` text NOT NULL,
  `is_correct` int(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_choices`
--

INSERT INTO `quiz_choices` (`choice_id`, `question_id`, `choice_text`, `is_correct`) VALUES
(193, 602, 'A', 0),
(194, 602, 'B', 1),
(195, 602, 'C', 0),
(196, 602, 'D', 0),
(197, 603, 'True', 1),
(198, 603, 'False', 0),
(199, 605, 'True', 1),
(200, 605, 'False', 0),
(201, 607, 'A', 1),
(202, 607, 'B', 0),
(203, 608, 'A', 0),
(204, 608, 'B', 1),
(205, 609, 'A', 1),
(206, 609, 'B', 0),
(207, 610, 'A', 1),
(208, 610, 'B', 0),
(209, 611, 'A', 0),
(210, 611, 'B', 1),
(211, 612, 'A', 0),
(212, 612, 'V', 1),
(213, 613, 'True', 1),
(214, 613, 'False', 0),
(215, 614, 'True', 1),
(216, 614, 'False', 0),
(217, 615, 'True', 1),
(218, 615, 'False', 0),
(219, 616, 'True', 1),
(220, 616, 'False', 0),
(221, 617, 'True', 1),
(222, 617, 'False', 0),
(223, 618, 'True', 1),
(224, 618, 'False', 0),
(225, 619, 'True', 1),
(226, 619, 'False', 0),
(227, 620, 'True', 1),
(228, 620, 'False', 0),
(229, 621, 'True', 1),
(230, 621, 'False', 0),
(231, 622, 'True', 1),
(232, 622, 'False', 0),
(233, 623, 'True', 1),
(234, 623, 'False', 0),
(235, 624, 'True', 1),
(236, 624, 'False', 0),
(237, 625, 'True', 1),
(238, 625, 'False', 0),
(239, 626, 'True', 1),
(240, 626, 'False', 0),
(241, 627, 'True', 1),
(242, 627, 'False', 0),
(257, 635, 'True', 1),
(258, 635, 'False', 0),
(259, 636, 'True', 1),
(260, 636, 'False', 0),
(261, 637, 'True', 0),
(262, 637, 'False', 1),
(263, 638, 'True', 0),
(264, 638, 'False', 1),
(289, 651, 'True', 1),
(290, 651, 'False', 0),
(291, 652, 'True', 1),
(292, 652, 'False', 0),
(293, 653, 'True', 0),
(294, 653, 'False', 1),
(295, 654, 'True', 0),
(296, 654, 'False', 1);

-- --------------------------------------------------------

--
-- Table structure for table `quiz_questions`
--

CREATE TABLE `quiz_questions` (
  `question_id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `question` text NOT NULL,
  `question_type` enum('multiple_choice','short_answer','true_false') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz_questions`
--

INSERT INTO `quiz_questions` (`question_id`, `quiz_id`, `question`, `question_type`, `created_at`) VALUES
(601, 98, 'What is a unique feature of UNIX based operating system?', 'short_answer', '2025-03-23 17:08:46'),
(602, 99, 'What is a unique feature of UNIX based operating system?', 'multiple_choice', '2025-03-23 17:09:21'),
(603, 100, 'True or False?', 'true_false', '2025-03-23 17:09:53'),
(604, 101, 'Question 1', 'short_answer', '2025-03-23 17:13:03'),
(605, 102, 'True or False?', 'true_false', '2025-03-23 17:40:31'),
(606, 103, 'Question 1', 'short_answer', '2025-03-29 09:30:05'),
(607, 104, 'What is a unique feature of UNIX based operating system?', 'multiple_choice', '2025-03-29 09:32:17'),
(608, 105, 'Question 1', 'multiple_choice', '2025-03-29 09:36:17'),
(609, 105, 'Question 2', 'multiple_choice', '2025-03-29 09:36:17'),
(610, 105, 'Question 3', 'multiple_choice', '2025-03-29 09:36:17'),
(611, 105, 'Question 2', 'multiple_choice', '2025-03-29 09:36:17'),
(612, 105, 'Question 2', 'multiple_choice', '2025-03-29 09:36:17'),
(613, 106, 'dsfdsf', 'true_false', '2025-04-02 13:54:02'),
(614, 106, 'gdfgf', 'true_false', '2025-04-02 13:54:02'),
(615, 106, 'fdgfdgd', 'true_false', '2025-04-02 13:54:02'),
(616, 106, 'dfgdfgfd', 'true_false', '2025-04-02 13:54:02'),
(617, 106, 'fdgfd', 'true_false', '2025-04-02 13:54:02'),
(618, 107, 'ddfsdf', 'true_false', '2025-04-02 14:06:07'),
(619, 107, 'cvxv', 'true_false', '2025-04-02 14:06:07'),
(620, 107, 'dfsdfds', 'true_false', '2025-04-02 14:06:07'),
(621, 107, 'vxcvcx', 'true_false', '2025-04-02 14:06:07'),
(622, 107, 'fgfdgfd', 'true_false', '2025-04-02 14:06:07'),
(623, 108, 'sadasd', 'true_false', '2025-04-02 14:11:35'),
(624, 108, 'xcvxcv', 'true_false', '2025-04-02 14:11:35'),
(625, 108, 'xvxcvxc', 'true_false', '2025-04-02 14:11:35'),
(626, 108, 'fvbcbv', 'true_false', '2025-04-02 14:11:35'),
(627, 108, 'fl,vl;c', 'true_false', '2025-04-02 14:11:35'),
(635, 111, 'sfgfsd', 'true_false', '2025-04-02 15:41:50'),
(636, 111, 'dsfd', 'true_false', '2025-04-02 15:41:50'),
(637, 111, 'ghfghgf', 'true_false', '2025-04-02 15:41:50'),
(638, 111, 'reterter', 'true_false', '2025-04-02 15:41:50'),
(651, 115, 'dghg', 'true_false', '2025-04-02 16:14:21'),
(652, 115, 'fdgfdg', 'true_false', '2025-04-02 16:14:21'),
(653, 115, 'vbvb', 'true_false', '2025-04-02 16:14:21'),
(654, 115, 'tryty', 'true_false', '2025-04-02 16:14:21');

-- --------------------------------------------------------

--
-- Table structure for table `student_answers`
--

CREATE TABLE `student_answers` (
  `answer_id` int(11) NOT NULL,
  `submission_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `student_answer` text NOT NULL,
  `choice_id` int(11) DEFAULT NULL,
  `is_correct` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_answers`
--

INSERT INTO `student_answers` (`answer_id`, `submission_id`, `question_id`, `student_answer`, `choice_id`, `is_correct`) VALUES
(137, 56, 602, '', 193, 0),
(138, 57, 601, 'paolo', NULL, 1),
(139, 58, 604, 'yes', NULL, 0),
(140, 59, 603, 'true', NULL, 0),
(141, 60, 608, '', 203, 0),
(142, 60, 609, '', 205, 1),
(143, 60, 610, '', 207, 1),
(144, 60, 611, '', 209, 0),
(145, 60, 612, '', 212, 1),
(146, 61, 614, 'true', NULL, 0),
(147, 61, 615, 'false', NULL, 0),
(148, 61, 616, 'false', NULL, 0),
(149, 61, 617, 'false', NULL, 0),
(150, 62, 618, 'true', NULL, 0),
(151, 62, 619, 'true', NULL, 0),
(152, 62, 620, 'true', NULL, 0),
(153, 62, 621, 'true', NULL, 0),
(154, 62, 622, 'true', NULL, 0),
(155, 63, 623, 'true', NULL, 0),
(156, 63, 624, 'true', NULL, 0),
(157, 63, 625, 'false', NULL, 0),
(158, 63, 626, 'false', NULL, 0),
(159, 63, 627, 'false', NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `student_classes`
--

CREATE TABLE `student_classes` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `class_id` int(11) NOT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_classes`
--

INSERT INTO `student_classes` (`id`, `student_id`, `class_id`, `assigned_at`) VALUES
(5, 20220169, 7, '2025-03-19 18:39:15'),
(6, 20220182, 8, '2025-03-19 19:02:08'),
(8, 20220169, 11, '2025-03-21 07:38:28'),
(9, 20220003, 15, '2025-03-28 18:23:54'),
(10, 20220634, 15, '2025-03-28 18:23:54'),
(11, 20221260, 15, '2025-03-28 18:23:54'),
(12, 20220111, 15, '2025-03-28 18:23:54'),
(13, 20210004, 15, '2025-03-28 18:23:54'),
(14, 20220912, 15, '2025-03-28 18:23:54'),
(15, 20220751, 15, '2025-03-28 18:23:54'),
(16, 20220841, 15, '2025-03-28 18:23:54'),
(17, 20220801, 15, '2025-03-28 18:23:54'),
(18, 20220749, 15, '2025-03-28 18:23:54'),
(19, 20220060, 15, '2025-03-28 18:23:54'),
(20, 19110182, 15, '2025-03-28 18:23:54'),
(21, 20201202, 15, '2025-03-28 18:23:54'),
(22, 20220703, 15, '2025-03-28 18:23:54'),
(23, 20220761, 15, '2025-03-28 18:23:54'),
(24, 20221054, 15, '2025-03-28 18:23:54'),
(25, 20220759, 15, '2025-03-28 18:23:54'),
(26, 20220172, 15, '2025-03-28 18:23:54'),
(27, 20220977, 15, '2025-03-28 18:23:54'),
(28, 20220823, 15, '2025-03-28 18:23:54'),
(29, 20220760, 15, '2025-03-28 18:23:54'),
(30, 20220007, 15, '2025-03-28 18:23:54'),
(31, 20220661, 15, '2025-03-28 18:23:54'),
(32, 20220743, 15, '2025-03-28 18:23:54'),
(33, 20220846, 15, '2025-03-28 18:23:54'),
(34, 20220772, 15, '2025-03-28 18:23:54'),
(35, 20220844, 15, '2025-03-28 18:23:54'),
(36, 20220842, 15, '2025-03-28 18:23:54'),
(37, 20221000, 15, '2025-03-28 18:23:54'),
(38, 20220564, 15, '2025-03-28 18:23:54'),
(39, 20220783, 15, '2025-03-28 18:23:54'),
(40, 20220779, 15, '2025-03-28 18:23:54'),
(41, 20220729, 15, '2025-03-28 18:23:54'),
(42, 20220763, 15, '2025-03-28 18:23:54'),
(44, 20220813, 15, '2025-03-28 18:23:54'),
(45, 20220721, 15, '2025-03-28 18:23:54'),
(46, 20220536, 15, '2025-03-28 18:23:54'),
(48, 20220129, 15, '2025-03-28 18:23:54'),
(49, 20220970, 14, '2025-03-29 01:59:18'),
(50, 20221206, 14, '2025-03-29 01:59:18'),
(51, 20220180, 14, '2025-03-29 01:59:18'),
(52, 20220806, 14, '2025-03-29 01:59:18'),
(53, 20220027, 14, '2025-03-29 01:59:18'),
(54, 20220081, 14, '2025-03-29 01:59:18'),
(55, 20220078, 14, '2025-03-29 01:59:18'),
(56, 20220041, 14, '2025-03-29 01:59:18'),
(57, 20190994, 14, '2025-03-29 01:59:18'),
(58, 20220012, 14, '2025-03-29 01:59:18'),
(59, 20220538, 14, '2025-03-29 01:59:18'),
(60, 20220532, 14, '2025-03-29 01:59:18'),
(61, 20220414, 14, '2025-03-29 01:59:18'),
(62, 20220521, 14, '2025-03-29 01:59:18'),
(63, 20220620, 14, '2025-03-29 01:59:18'),
(64, 20220157, 14, '2025-03-29 01:59:18'),
(65, 20220945, 14, '2025-03-29 01:59:18'),
(66, 20220152, 14, '2025-03-29 01:59:18'),
(67, 20220314, 14, '2025-03-29 01:59:18'),
(68, 20220346, 14, '2025-03-29 01:59:18'),
(69, 20220568, 14, '2025-03-29 01:59:18'),
(70, 20220436, 14, '2025-03-29 01:59:18'),
(71, 20220633, 14, '2025-03-29 01:59:18'),
(72, 20220659, 14, '2025-03-29 01:59:18'),
(73, 20220026, 14, '2025-03-29 01:59:18'),
(74, 20220600, 14, '2025-03-29 01:59:18'),
(75, 20211490, 14, '2025-03-29 01:59:18'),
(76, 20220928, 14, '2025-03-29 01:59:18'),
(77, 20220085, 14, '2025-03-29 01:59:18'),
(78, 20220355, 14, '2025-03-29 01:59:18'),
(79, 20220665, 14, '2025-03-29 01:59:18'),
(80, 20220240, 14, '2025-03-29 01:59:18'),
(81, 20220340, 14, '2025-03-29 01:59:18'),
(82, 20220753, 14, '2025-03-29 01:59:18'),
(83, 20220449, 14, '2025-03-29 01:59:18'),
(84, 20220986, 14, '2025-03-29 01:59:18'),
(85, 20220112, 14, '2025-03-29 01:59:18'),
(86, 20220765, 14, '2025-03-29 01:59:18'),
(87, 20220934, 14, '2025-03-29 01:59:18'),
(88, 20220086, 14, '2025-03-29 01:59:18'),
(89, 20220169, 16, '2025-03-29 09:28:00'),
(90, 20220182, 16, '2025-03-29 09:28:40');

-- --------------------------------------------------------

--
-- Table structure for table `student_quiz_submission`
--

CREATE TABLE `student_quiz_submission` (
  `submission_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `status` enum('pending','graded') DEFAULT 'pending',
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_quiz_submission`
--

INSERT INTO `student_quiz_submission` (`submission_id`, `member_id`, `quiz_id`, `score`, `status`, `submitted_at`) VALUES
(56, 20220169, 99, 0, 'graded', '2025-03-23 17:11:17'),
(57, 20220169, 98, 1, 'graded', '2025-03-23 17:11:49'),
(58, 20220169, 101, 0, 'graded', '2025-03-23 17:13:21'),
(59, 20220169, 100, 0, 'graded', '2025-03-23 17:40:51'),
(60, 20220182, 105, 0, 'graded', '2025-03-29 09:37:41'),
(61, 20220169, 106, 0, 'pending', '2025-04-02 13:54:25'),
(62, 20220169, 107, 0, 'graded', '2025-04-02 14:06:27'),
(63, 20220169, 108, 0, 'graded', '2025-04-02 14:11:53');

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `member_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `is_enabled` tinyint(4) DEFAULT 1,
  `status` enum('enabled','disabled') DEFAULT 'enabled',
  `contact` varchar(15) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `has_accepted_policy` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`member_id`, `name`, `email`, `password`, `role`, `is_enabled`, `status`, `contact`, `profile_picture`, `has_accepted_policy`) VALUES
(19110182, 'COMPETENTE, ANNENA CAMBI', 'competentearwenna.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20190994, 'DELOS REYES, AARON VINCENT MANLAPAZ', 'delosreyesaaron.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20201202, 'CUADERNO, NICOLE MAYA', 'cuadernonicole.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20210004, 'BARCENA, DIVINE GRACE DAWAL', 'barcenadivinegrcae.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20211490, 'ANZA, AIRA JOYCE NAVARRO', 'anzaairajoyce.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220003, 'ADALID, JOHN SIMON DIAZ', 'abalosjomar.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220007, 'LEYNES, CHRISTOPHER FIESTA', 'leyneschristopher.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220012, 'DOMINGO, GABRIEL CUBALAN', 'domingogabriel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220026, 'VERGARA, JOVIN LEE', 'vergarajovin.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220027, 'CASTRO, KURT LOUIE CASTRO', 'castrokurtlouie.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220041, 'DAVAC, VINCENT AHRON MANTUHAC', 'davacvincent.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220060, 'CHAN, IAN MYRON LUNA', 'chanian.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220078, 'CRUZ, DANIKEN SANTOS', 'cruzdanikens.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220081, 'COLENDRES, SHERWIN BONIFACIO', 'colendressherwin.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220085, 'BIAGTAS, ALTHEA NICOLE LAGUNA', 'biagtasalthea11.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220086, 'VINLUAN, AILA RAMOS', 'vinluanaila.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220111, 'BAENA, VINCE IVERSON CAMACHO', 'baenavinceiverson.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220112, 'PUNO, LOURINE ASHANTI MATEL', 'punolourineashanti.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220129, 'URETA, JAN EDMAINE DELA TORRE', 'uretajanermaine.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220152, 'MANGALINDAN, JEROME TAMAYO', 'jeromemangalindan.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220157, 'LENDO, REYMART DELAGUNA', 'lendoreymart.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220168, 'TORRES, KINO ANDREI NAZARENO', 'torreskiddandrei.bsit@gmail.com', '7a0c3cd72198d6d33366d4f33508b1de', 'teacher', 1, 'enabled', '', '67d2340a4aaf0.png', 0),
(20220169, 'ROSALES, PAOLO GADO', 'rosalespaolo.bsit@gmail.com', 'ba6c0c558104faa71be0cf303ad21d82', 'student', 1, 'enabled', '09052744170', '67c4427d91862.jpg', 0),
(20220172, 'GARDON, MARK CHRISTIAN', 'gardonmark.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220180, 'CARANAY, MYCO KENT MIRALLES', 'caranaymycokent@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220182, 'Arwena', 'competentearwena.bsit@gmail.com', 'f204c3e977dc7e988f9045ec30165b0d', 'student', 1, 'enabled', NULL, NULL, 0),
(20220185, 'admin', 'admin@gmail.com', '0192023a7bbd73250516f069df18b500', 'admin', 1, 'enabled', NULL, NULL, 0),
(20220240, 'CORONADO, JENNY MAE DE CASTRO', 'coronadojennymae.bsit@gmail', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220314, 'PAGHUNASAN, MARVIN JUN CASINGAL', 'paghunasanmarvinjun.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220340, 'FAJARDO, MICHAELLA ESTABAYA', 'fajardomichaella.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220346, 'PANDI, LIAM RYU INGEL', 'pandiliamryu.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220355, 'BUMADILLA, BERNADETTE BARON', 'bumadillabernadette.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220414, 'GUARIN, JOSHUA RAPHAEL ADMAN', 'guarinjoshuaraphael.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220436, 'RAMIREZ, CLARENCE IVER ACOVERA', 'ramirezclarence.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220449, 'MARCIANO, TRISHA MAE JAVIER', 'marcianotrishamae.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220521, 'IBE, JOHN MICHAEL BATALLER', 'ibejohnmichael.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220532, 'GONZALO, SEAN RUZZEL ABSALON', 'gonzaloseanruzzel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220536, 'SILLA, ELLAINE ROSE AQUINO', 'sillaellainerose.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220538, 'ESTRADA, NOELLE JAMES CORTINA', 'estradanoellejames.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220564, 'OCHEA, MICHAEL JAMES NOGULAN', 'ocheamichaeljames.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220568, 'POSTRADO, CHARLES JACOB CASTILLO', 'postradocharles.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220600, 'VERGARA, KURT DARYL CAGADAS', 'vergarakurt.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220620, 'IGNACIO JR., ELDIE GOLLE', 'ignacioeldiejr.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220633, 'SIWA, JASON GARCIA', 'siwajason.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220634, 'ANGUSTIA, MERIENSON DIZON', 'angustiamerienor.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220659, 'VASQUEZ, BRENT BRIAN FORDELON', 'vasquezbrentbrian.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220661, 'MACALALAD, MARK GIL GUEVARRE', 'macaloodmarkgil.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220665, 'CABALLERO, FAITH KEISHA RESURRECCION', 'caballerofaithkeisha.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220703, 'DE JESUS III, ELMER BRIAN PAYUMO', 'dejesuselmer.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220721, 'SANTIAGO, MARK LOUIS MESA', 'santiagomarklouis.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220729, 'RIVERA, MA. ANGEL DELA CRUZ', 'riveramaangel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220743, 'MACLAYON, JEREMY TADALAN', 'maglayonjeremy.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220749, 'CERBITO, JOBERT CARILLO', 'cerbitojobert.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220751, 'BELEN, JOHN JOSEPH GUNIO', 'belenjohnjoseph.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220753, 'LLORCA, BERNADETH DELA CRUZ', 'llorcabernadeth.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220759, 'GARCIA, PRINCE AUGUST MONTEMAYOR', 'garciaprince.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220760, 'LAURENO, CHRISTIAN JAY VICTORIA', 'laurenochristian.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220761, 'DYPANGCO, IVAN SOLAMO', 'dypangcoivan.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220763, 'RODRIGUEZ, RENZEL ROSADINO', 'rodriguezrenzel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220765, 'RODAS, MA. HELEN MARIE YAMBOT', 'rodasmahelenmarie.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220772, 'MANGULIT, RASHCEL CHRISTIAN DE PEDRO', 'mangilitnashcel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220779, 'PANUGAN, CHRISTIAN RAFAEL CARIGAS', 'panuganchristian.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220783, 'PANALIGAN, ANDREI MATIC', 'panaliganandrei.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220801, 'BITANCUR, JOHN LAWRENCE LOPEZ', 'bitancurjohnlawrence.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220806, 'CARLOS, LUIS MARIO FILIO', 'carlosluismario.bsit@gmai.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220813, 'SACHO, ALEXIS OCUMEN', 'sacroalexis.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220823, 'JOEL, MATT JONAS TUALLA', 'joelmatt.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220841, 'BERMAS, MARIENNE CHELO DELOS SANTOS', 'bermasmariannechelo.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220842, 'MORALES, JESTHER MINACE', 'moralesjeseree.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220844, 'MENDOZA, IRVIN DYNNIE FONTANARES', 'mendozarain.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220846, 'MAHALO, CYRIL SIOTE', 'manalocybel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220912, 'BAYOBAY, MYLENE LAWITAN', 'bayobaymylene.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220928, 'BARNUEVO, EIZLEY RAMOS', 'barnuevoeizley.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220934, 'TIMONERA,CHRIST JOHN MARIE ABEJARON', 'timonerachristjohnmarie.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220945, 'LIM, KIAN SHANE OROSCO', 'limkianshane.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220970, 'CABUEÑOS, JHOB ISAAC SUMIL', 'cabuenosjhob.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220977, 'GREGORIO, JAMES RYAN OLANIGA', 'gregoriojames.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20220986, 'PUNLA, JOYCE ANNE OCAMPO', 'punlajoyceanne.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20221000, 'NICOLAS, KENZ BRUNO SORIANO', 'nicolaskenz.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20221054, 'FEGURO, MIGUEL DEMATRIA', 'feguromiguel.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20221206, 'CALUPCUPAN, MARC JUSTIN PUNZAL', 'calupcupan.marcjustin.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0),
(20221260, 'AZUCENA, JOHN ANDRIE VERDIN', 'azucenajohnandrie.bsit@gmail.com', NULL, 'student', 1, 'enabled', NULL, NULL, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classes`
--
ALTER TABLE `classes`
  ADD PRIMARY KEY (`class_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `idx_quiz_member_id` (`member_id`);

--
-- Indexes for table `quiz_answers`
--
ALTER TABLE `quiz_answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `fk_correct_answer_choice` (`correct_answer`);

--
-- Indexes for table `quiz_choices`
--
ALTER TABLE `quiz_choices`
  ADD PRIMARY KEY (`choice_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD PRIMARY KEY (`answer_id`),
  ADD KEY `question_id` (`question_id`),
  ADD KEY `idx_student_answer_submission_id` (`submission_id`);

--
-- Indexes for table `student_classes`
--
ALTER TABLE `student_classes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Indexes for table `student_quiz_submission`
--
ALTER TABLE `student_quiz_submission`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `quiz_id` (`quiz_id`),
  ADD KEY `idx_submission_member_id` (`member_id`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`member_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `member_id` (`member_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `classes`
--
ALTER TABLE `classes`
  MODIFY `class_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=117;

--
-- AUTO_INCREMENT for table `quiz_answers`
--
ALTER TABLE `quiz_answers`
  MODIFY `answer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

--
-- AUTO_INCREMENT for table `quiz_choices`
--
ALTER TABLE `quiz_choices`
  MODIFY `choice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=297;

--
-- AUTO_INCREMENT for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=655;

--
-- AUTO_INCREMENT for table `student_answers`
--
ALTER TABLE `student_answers`
  MODIFY `answer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=163;

--
-- AUTO_INCREMENT for table `student_classes`
--
ALTER TABLE `student_classes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `student_quiz_submission`
--
ALTER TABLE `student_quiz_submission`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20221261;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_member` FOREIGN KEY (`member_id`) REFERENCES `user_info` (`member_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user_info` (`member_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user_info` (`member_id`);

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user_info` (`member_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_answers`
--
ALTER TABLE `quiz_answers`
  ADD CONSTRAINT `fk_quiz_answers_question` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_answers_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_answers_ibfk_2` FOREIGN KEY (`correct_answer`) REFERENCES `quiz_choices` (`choice_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_choices`
--
ALTER TABLE `quiz_choices`
  ADD CONSTRAINT `quiz_choices_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz_questions`
--
ALTER TABLE `quiz_questions`
  ADD CONSTRAINT `fk_quiz_questions_quiz` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quiz_questions_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD CONSTRAINT `fk_student_answers_question` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_student_answers_submission` FOREIGN KEY (`submission_id`) REFERENCES `student_quiz_submission` (`submission_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_answers_ibfk_1` FOREIGN KEY (`submission_id`) REFERENCES `student_quiz_submission` (`submission_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_answers_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `quiz_questions` (`question_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_classes`
--
ALTER TABLE `student_classes`
  ADD CONSTRAINT `student_classes_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user_info` (`member_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_classes_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `classes` (`class_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_quiz_submission`
--
ALTER TABLE `student_quiz_submission`
  ADD CONSTRAINT `student_quiz_submission_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `user_info` (`member_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_quiz_submission_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
