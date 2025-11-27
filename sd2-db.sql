-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Generation Time: Oct 30, 2022 at 09:54 AM
-- Server version: 8.0.24
-- PHP Version: 7.4.20

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

--
-- Indexes for dumped tables
--

--
-- Indexes for table `test_table`
--
ALTER TABLE `test_table`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `test_table`
--
ALTER TABLE `test_table`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- --------------------------------------------------------

--
-- Table structure for table `authors`
--

CREATE TABLE `authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `bio` text,
  `website` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `authors_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `publishers`
--

CREATE TABLE `publishers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `website` varchar(512) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `publishers_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_name_unique` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `id` bigint NOT NULL AUTO_INCREMENT,
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
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `books_isbn_13_unique` (`isbn_13`),
  UNIQUE KEY `books_isbn_10_unique` (`isbn_10`),
  KEY `books_author_fk` (`author_id`),
  KEY `books_publisher_fk` (`publisher_id`),
  CONSTRAINT `books_author_fk` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `books_publisher_fk` FOREIGN KEY (`publisher_id`) REFERENCES `publishers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `book_categories`
--

CREATE TABLE `book_categories` (
  `book_id` bigint NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`book_id`,`category_id`),
  KEY `book_categories_category_fk` (`category_id`),
  CONSTRAINT `book_categories_book_fk` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_categories_category_fk` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Seed data for authors
--
INSERT INTO `authors` (`name`, `bio`, `website`) VALUES
('Haruki Murakami', 'Japanese writer known for blending surrealism with everyday life.', 'https://www.harukimurakami.com'),
('Chimamanda Ngozi Adichie', 'Nigerian author of novels, short stories, and nonfiction.', 'https://www.chimamanda.com'),
('Andy Weir', 'American novelist known for science-based speculative fiction.', 'https://www.andyweirauthor.com');

--
-- Seed data for publishers
--
INSERT INTO `publishers` (`name`, `website`) VALUES
('Knopf', 'https://knopfdoubleday.com'),
('Fourth Estate', 'https://www.harpercollins.co.uk/imprints/fourth-estate'),
('Crown', 'https://www.penguinrandomhouse.com/imprints/crown');

--
-- Seed data for categories
--
INSERT INTO `categories` (`name`) VALUES
('Literary Fiction'),
('Science Fiction'),
('Magical Realism');

--
-- Seed data for books
--
INSERT INTO `books` (`title`, `subtitle`, `author_id`, `publisher_id`, `isbn_10`, `isbn_13`, `language`, `page_count`, `format`, `publication_date`, `description`, `cover_image_url`) VALUES
('Kafka on the Shore', NULL, 1, 1, '1400079276', '9781400079278', 'English', 480, 'Paperback', '2005-01-03', 'A coming-of-age tale intertwining a runaway teen and an aging man who can talk to cats.', 'https://images.example.com/kafka-on-the-shore.jpg'),
('Half of a Yellow Sun', NULL, 2, 2, '0007200285', '9780007200283', 'English', 448, 'Paperback', '2006-08-01', 'Story of love and war set during the Biafran War in Nigeria.', 'https://images.example.com/half-of-a-yellow-sun.jpg'),
('Project Hail Mary', NULL, 3, 3, '0593135202', '9780593135204', 'English', 496, 'Hardcover', '2021-05-04', 'An astronaut wakes alone on a ship and must save Earth with the help of an unexpected ally.', 'https://images.example.com/project-hail-mary.jpg');

--
-- Seed data for book_categories
--
INSERT INTO `book_categories` (`book_id`, `category_id`) VALUES
(1, 3),
(1, 1),
(2, 1),
(3, 2);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
