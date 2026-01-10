-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 11:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `adoption_status` varchar(20) DEFAULT 'pending',
  `request_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `pet_id`, `user_id`, `message`, `adoption_status`, `request_date`) VALUES
(1, 2, 17, 'odmdo', 'pending', '2026-01-10 16:19:36'),
(2, 1, 17, 'iedi', 'pending', '2026-01-10 16:21:16'),
(3, 8, 17, 'i want him', 'pending', '2026-01-10 16:31:57'),
(4, 1, 17, 'i need a bird', 'pending', '2026-01-10 16:33:17');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `donation_type` varchar(20) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `user_id`, `pet_id`, `donation_type`, `amount`, `description`, `created_at`) VALUES
(1, 1, 6, 'money', 20.00, '', '2026-01-10 16:01:41'),
(2, 17, 6, 'money', 30.00, '', '2026-01-10 16:34:46'),
(3, 17, 6, 'food', 0.00, 'i will give food ath the petshop', '2026-01-10 16:35:24'),
(4, 17, 4, 'medical', 0.00, 'you can come to my vet, iwill give for free', '2026-01-10 16:36:49');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `images` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `images`, `created_at`) VALUES
(1, 1, 'dodo', 'other', 'adoption', 'i need to go oversea', '37.4219983', '-122.084', 'uploads/pet_user_1_1.png', '2026-01-10 15:32:53'),
(2, 1, 'fluffy', 'rabbit', 'donation request', 'need some donation to buy her medicine', '37.4219983', '-122.084', 'uploads/pet_user_1_2.png', '2026-01-10 15:52:51'),
(3, 1, 'swiper', 'other', 'adoption', 'too naughty', '37.4219983', '-122.084', 'uploads/pet_user_1_3.png', '2026-01-10 15:54:24'),
(4, 1, 'gulu', 'other', 'donation request', 'need donation to buy  food for gulu', '37.4219983', '-122.084', 'uploads/pet_user_1_4.png', '2026-01-10 15:55:43'),
(5, 1, 'goofy', 'dog', 'help/rescue', 'need help to take care of him while i\'m not around', '37.4219983', '-122.084', 'uploads/pet_user_1_5.png', '2026-01-10 15:56:42'),
(6, 1, 'masbro', 'cat', 'donation request', 'need donation to do her surgery', '37.4219983', '-122.084', 'uploads/pet_user_1_6.png', '2026-01-10 15:57:46'),
(7, 17, 'ami', 'rabbit', 'adoption', 'i need someone who able to adopt her', '37.4219983', '-122.084', 'uploads/pet_user_17_7.png', '2026-01-10 16:13:26'),
(8, 17, 'wipi', 'dog', 'adoption', 'nakal', '37.4219983', '-122.084', 'uploads/pet_user_17_8.png', '2026-01-10 16:31:41');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_phone` varchar(20) NOT NULL,
  `user_regdate` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_name`, `user_email`, `user_password`, `user_phone`, `user_regdate`, `user_image`) VALUES
(1, 'dwilhidayatbinlasumardi', 'dwi@gmail.com', '03cb3d0958c37eff1579d63639b6870f186bdc23', '01151194291', '2025-11-26 03:31:28.180233', 'uploads/profile/profile_user_1.png'),
(2, 'mets', 'meto@gmail.com', 'b00317c9a603eba83779b999f3092938971639a1', '012456378', '2025-11-26 03:34:25.639894', NULL),
(3, 'amir sabri', 'amir@gmail.com', 'cb5268237eefe29c7651d2a12302f323edfbd49a', '0167870957', '2025-11-26 03:43:49.768676', 'uploads/profile/profile_user_3.png'),
(4, 'hidayat', 'hidayat@gmail.com', 'eb0bf0bed98b3249a99eaa78c999c275ce0674e5', '01151194291', '2025-11-26 03:46:46.382310', NULL),
(5, 'sabri', 'sabri@gmail.com', '739d49c60e5e9b914b9adc36bb4bec5377c2092b', '0987654321', '2025-11-26 04:07:06.727161', NULL),
(6, 'zamir', 'zamir@gmail.com', '06aaa987720f20c971f1e3adc88135d2bcc19816', '0978654321', '2025-11-26 04:13:37.725184', NULL),
(7, 'udin', 'udin@gmail.com', '2ddb27b2cf0dccc03ea9c65368813c3dc348337d', '0112567489', '2025-11-26 04:16:03.495577', NULL),
(8, 'shah', 'shah@gmail.com', 'ca94b4da276db76e885e98a5171ca7a7158f9932', '0112567489', '2025-11-26 04:17:33.077797', NULL),
(9, 'abu', 'abu@gmail.com', '0b57bbbe6bc57309ce0e273753b947d60ad46b5b', '0137846736', '2025-11-26 04:21:30.968335', NULL),
(10, 'mirul', 'mirul@gmail.com', '88f848038da8fe74cc691089b560648d47fc7597', '01783764578', '2025-11-26 04:30:49.142833', NULL),
(11, 'zaki', 'zaki@gmail.com', 'de9b873d01c754e97078524b59c1932a0c8aacda', '01764837645', '2025-11-26 04:47:26.915429', NULL),
(12, 'arman', 'arman@gmail.com', '2344caab9d8f08edc3f41299bc3e806f754da1f3', '015783764', '2025-11-26 05:08:01.172488', NULL),
(13, 'usup', 'usup@gmail.com', 'cceec4bcd8d9d914f36bf6541fb93110ef1851c8', '0178463784', '2025-11-26 05:40:15.255403', NULL),
(14, 'pias', 'pia@gmail.com', 'e3483f39e89405e4c6ac4b6748cdc8913c518707', '0111111111', '2025-11-26 05:42:22.651666', 'uploads/profile/profile_user_14.png'),
(15, 'kasyfi', 'kasyfi@gmail.com', '8b163c835f55db51ff21c8a3b6b13789c580f97f', '015638298', '2025-12-05 20:57:02.600403', NULL),
(16, 'awi', 'awi@gmail.com', 'a193c799a40be3f5e5f1ee39ff29fa8570ccb3d3', '0987654321', '2026-01-10 15:50:56.803520', NULL),
(17, 'yuta123', 'yuta@gmail.com', 'ef2fc730bd01c580b9f0f29c93f908154ac23e44', '014568398767', '2026-01-10 16:10:31.326352', 'uploads/profile/profile_user_17.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `tbl_pets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
