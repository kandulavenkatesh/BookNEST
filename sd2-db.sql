-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db:3306
-- Generation Time: Dec 17, 2025 at 10:01 AM
-- Server version: 9.5.0
-- PHP Version: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sd2-db`
--

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `bio` text,
  `website` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `authors`
--

INSERT INTO `authors` (`id`, `name`, `bio`, `website`, `created_at`, `updated_at`) VALUES
(1, 'Haruki Murakami', 'Japanese writer known for blending surrealism with everyday life.', 'https://www.harukimurakami.com', '2025-12-16 20:54:33', '2025-12-16 20:54:33'),
(2, 'Chimamanda Ngozi Adichie', 'Nigerian author of novels, short stories, and nonfiction.', 'https://www.chimamanda.com', '2025-12-16 20:54:33', '2025-12-16 20:54:33'),
(3, 'Andy Weir', 'American novelist known for science-based speculative fiction.', 'https://www.andyweirauthor.com', '2025-12-16 20:54:33', '2025-12-16 20:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `author_id` int NOT NULL,
  `publisher_id` int DEFAULT NULL,
  `isbn_10` varchar(10) DEFAULT NULL,
  `isbn_13` varchar(13) DEFAULT NULL,
  `language` varchar(32) DEFAULT NULL,
  `page_count` int DEFAULT NULL,
  `format` varchar(32) DEFAULT NULL,
  `publication_date` date DEFAULT NULL,
  `description` text,
  `cover_image_url` varchar(512) DEFAULT NULL,
  `book_upload` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`id`, `title`, `subtitle`, `author_id`, `publisher_id`, `isbn_10`, `isbn_13`, `language`, `page_count`, `format`, `publication_date`, `description`, `cover_image_url`, `book_upload`, `created_at`, `updated_at`) VALUES
(1, 'Kafka on the Shore', NULL, 1, 1, '1400079276', '9781400079278', 'English', 481, 'Paperback', '2005-01-03', 'A coming-of-age tale intertwining a runaway teen and an aging man who can talk to cats.', 'https://m.media-amazon.com/images/I/3190fsfp48L._SY445_SX342_ControlCacheEqualizer_.jpg', NULL, '2025-12-16 20:54:33', '2025-12-17 09:13:14'),
(2, 'Half of a Yellow Sun', NULL, 2, 2, '0007200285', '9780007200283', 'English', 448, 'Paperback', '2006-08-01', 'Story of love and war set during the Biafran War in Nigeria.', 'https://d.gr-assets.com/books/1320400088l/1102116.jpg', NULL, '2025-12-16 20:54:33', '2025-12-16 20:54:33'),
(3, 'Project Hail Mary', NULL, 3, 3, '0593135202', '9780593135204', 'English', 496, 'Hardcover', '2021-05-04', 'An astronaut wakes alone on a ship and must save Earth with the help of an unexpected ally.', 'https://m.media-amazon.com/images/I/51HLmk9ufLL._SY445_SX342_ControlCacheEqualizer_.jpg', NULL, '2025-12-16 20:54:33', '2025-12-16 20:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `book_categories`
--

CREATE TABLE `book_categories` (
  `book_id` bigint NOT NULL,
  `category_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `book_categories`
--

INSERT INTO `book_categories` (`book_id`, `category_id`) VALUES
(1, 1),
(2, 1),
(3, 2),
(1, 3);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL,
  `name` varchar(128) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `created_at`) VALUES
(1, 'Literary Fiction', '2025-12-16 20:54:33'),
(2, 'Science Fiction', '2025-12-16 20:54:33'),
(3, 'Magical Realism', '2025-12-16 20:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE `publishers` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `website` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `publishers`
--

INSERT INTO `publishers` (`id`, `name`, `website`, `created_at`, `updated_at`) VALUES
(1, 'Knopf', 'https://knopfdoubleday.com', '2025-12-16 20:54:33', '2025-12-16 20:54:33'),
(2, 'Fourth Estate', 'https://www.harpercollins.co.uk/imprints/fourth-estate', '2025-12-16 20:54:33', '2025-12-16 20:54:33'),
(3, 'Crown', 'https://www.penguinrandomhouse.com/imprints/crown', '2025-12-16 20:54:33', '2025-12-16 20:54:33');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int NOT NULL,
  `book_id` bigint NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `book_id`, `user_id`, `rating`, `comment`, `created_at`) VALUES
(1, 1, 2, 5, 'very nice book.', '2025-12-17 09:59:04');

-- --------------------------------------------------------

--
-- Table structure for table `test_table`
--

CREATE TABLE `test_table` (
  `id` int NOT NULL,
  `name` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `test_table`
--

INSERT INTO `test_table` (`id`, `name`) VALUES
(1, 'Lisa'),
(2, 'Kimia');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `user_id` int NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `username`, `email`, `password`, `created_at`) VALUES
(1, 'admin', 'admin@gmail.com', '$2b$10$Joganf0WCVHItPXdnUnsoe91u6NE5Q5bVjYftM1qTU1IkeEIG73jG', '2025-12-16 20:54:39'),
(2, 'user', 'user@gmail.com', '$2b$10$mUap3BHxNhnDwvo9cPyI2.mhM0kC7m1RjNeBO46ChyHSGVIKC6NXq', '2025-12-17 09:19:39');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `authors`
--
ALTER TABLE `authors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `authors_name_unique` (`name`);

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `books_isbn_13_unique` (`isbn_13`),
  ADD UNIQUE KEY `books_isbn_10_unique` (`isbn_10`),
  ADD KEY `books_author_fk` (`author_id`),
  ADD KEY `books_publisher_fk` (`publisher_id`);

--
-- Indexes for table `book_categories`
--
ALTER TABLE `book_categories`
  ADD PRIMARY KEY (`book_id`,`category_id`),
  ADD KEY `book_categories_category_fk` (`category_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name_unique` (`name`);

--
-- Indexes for table `publishers`
--
ALTER TABLE `publishers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `publishers_name_unique` (`name`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_book` (`book_id`,`user_id`),
  ADD KEY `reviews_user_fk` (`user_id`);

--
-- Indexes for table `test_table`
--
ALTER TABLE `test_table`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `authors`
--
ALTER TABLE `authors`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `publishers`
--
ALTER TABLE `publishers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `test_table`
--
ALTER TABLE `test_table`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `books`
--
ALTER TABLE `books`
  ADD CONSTRAINT `books_author_fk` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `books_publisher_fk` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `book_categories`
--
ALTER TABLE `book_categories`
  ADD CONSTRAINT `book_categories_book_fk` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `book_categories_category_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_book_fk` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reviews_user_fk` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
