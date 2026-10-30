-- ============================================================================
-- Shipping Management System - database structure + required base data
-- Laravel 7 / MySQL 5.7+ (or MariaDB 10.3+)  -  charset utf8mb4
--
-- Contains: all tables, the default roles and their permissions, the `migrations`
-- records (so `php artisan migrate` knows the schema is already installed) and
-- one administrator account.
--
--   Admin login:  admin@shipping.test   /   password      (change it after the first login)
--
-- WARNING: the DROP TABLE statements below delete any existing data in these tables.
--
-- How to import
--   phpMyAdmin : select your database (the one in .env DB_DATABASE) > Import > choose this file
--   Command line: mysql -u root -p your_database < shipping_system.sql
--
-- To create the database from this script, uncomment the next two lines (use your own name):
-- CREATE DATABASE IF NOT EXISTS `shipping-system` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE `shipping-system`;
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'NO_AUTO_VALUE_ON_ZERO';

-- ---------------------------------------------------------------- tables
DROP TABLE IF EXISTS `migrations`;
DROP TABLE IF EXISTS `branch_user`;
DROP TABLE IF EXISTS `user_permissions`;
DROP TABLE IF EXISTS `role_user`;
DROP TABLE IF EXISTS `permission_role`;
DROP TABLE IF EXISTS `roles`;
DROP TABLE IF EXISTS `user_notifications`;
DROP TABLE IF EXISTS `invoice_items`;
DROP TABLE IF EXISTS `invoices`;
DROP TABLE IF EXISTS `shipment_histories`;
DROP TABLE IF EXISTS `shipments`;
DROP TABLE IF EXISTS `couriers`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `branches`;
DROP TABLE IF EXISTS `failed_jobs`;

CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `branches` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `city` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `branches_code_unique` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `branch_id` bigint unsigned DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `work_type` varchar(20) NOT NULL DEFAULT 'branch',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  KEY `users_branch_id_foreign` (`branch_id`),
  CONSTRAINT `users_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `customers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `company` varchar(255) DEFAULT NULL,
  `phone` varchar(30) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `notes` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customers_phone_index` (`phone`),
  KEY `customers_branch_id_foreign` (`branch_id`),
  CONSTRAINT `customers_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `couriers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `branch_id` bigint unsigned DEFAULT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(30) NOT NULL,
  `national_id` varchar(30) DEFAULT NULL,
  `vehicle_type` varchar(30) NOT NULL DEFAULT 'motorcycle',
  `vehicle_number` varchar(30) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'available',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `couriers_branch_id_foreign` (`branch_id`),
  KEY `couriers_user_id_foreign` (`user_id`),
  CONSTRAINT `couriers_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `couriers_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `shipments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tracking_number` varchar(30) NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `branch_id` bigint unsigned DEFAULT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `courier_id` bigint unsigned DEFAULT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `invoice_id` bigint unsigned DEFAULT NULL,
  `origin_city` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `receiver_phone` varchar(30) NOT NULL,
  `receiver_city` varchar(255) NOT NULL,
  `receiver_address` varchar(255) NOT NULL,
  `service_type` varchar(20) NOT NULL DEFAULT 'standard',
  `weight` decimal(8,2) NOT NULL DEFAULT '1.00',
  `pieces` int unsigned NOT NULL DEFAULT '1',
  `description` varchar(255) DEFAULT NULL,
  `shipping_cost` decimal(10,2) NOT NULL DEFAULT '0.00',
  `payment_method` varchar(20) NOT NULL DEFAULT 'prepaid',
  `cod_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `status` varchar(30) NOT NULL DEFAULT 'pending',
  `expected_delivery` date DEFAULT NULL,
  `delivered_at` timestamp NULL DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `pickup_type` varchar(20) NOT NULL DEFAULT 'pickup',
  `receiver_phone2` varchar(30) DEFAULT NULL,
  `receiver_district` varchar(255) DEFAULT NULL,
  `receiver_landmark` varchar(255) DEFAULT NULL,
  `package_type` varchar(30) NOT NULL DEFAULT 'parcel',
  `length` decimal(8,2) DEFAULT NULL,
  `width` decimal(8,2) DEFAULT NULL,
  `height` decimal(8,2) DEFAULT NULL,
  `is_fragile` tinyint(1) NOT NULL DEFAULT '0',
  `allow_open` tinyint(1) NOT NULL DEFAULT '0',
  `goods_value` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shipping_payer` varchar(20) NOT NULL DEFAULT 'sender',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shipments_tracking_number_unique` (`tracking_number`),
  KEY `shipments_invoice_id_index` (`invoice_id`),
  KEY `shipments_status_index` (`status`),
  KEY `shipments_branch_id_foreign` (`branch_id`),
  KEY `shipments_customer_id_foreign` (`customer_id`),
  KEY `shipments_courier_id_foreign` (`courier_id`),
  KEY `shipments_created_by_foreign` (`created_by`),
  CONSTRAINT `shipments_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_courier_id_foreign` FOREIGN KEY (`courier_id`) REFERENCES `couriers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `shipments_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `shipment_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `shipment_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `status` varchar(30) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shipment_histories_shipment_id_foreign` (`shipment_id`),
  KEY `shipment_histories_user_id_foreign` (`user_id`),
  CONSTRAINT `shipment_histories_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shipment_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `invoices` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_number` varchar(30) NOT NULL,
  `branch_id` bigint unsigned DEFAULT NULL,
  `customer_id` bigint unsigned NOT NULL,
  `created_by` bigint unsigned DEFAULT NULL,
  `issue_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `tax_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `tax_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total` decimal(12,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) NOT NULL DEFAULT 'unpaid',
  `paid_at` timestamp NULL DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_number_unique` (`invoice_number`),
  KEY `invoices_status_index` (`status`),
  KEY `invoices_branch_id_foreign` (`branch_id`),
  KEY `invoices_customer_id_foreign` (`customer_id`),
  KEY `invoices_created_by_foreign` (`created_by`),
  CONSTRAINT `invoices_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE SET NULL,
  CONSTRAINT `invoices_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `invoices_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `invoice_items` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint unsigned NOT NULL,
  `shipment_id` bigint unsigned DEFAULT NULL,
  `kind` varchar(20) NOT NULL DEFAULT 'shipping',
  `description` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `shipping_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_items_invoice_id_foreign` (`invoice_id`),
  KEY `invoice_items_shipment_id_foreign` (`shipment_id`),
  CONSTRAINT `invoice_items_invoice_id_foreign` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE,
  CONSTRAINT `invoice_items_shipment_id_foreign` FOREIGN KEY (`shipment_id`) REFERENCES `shipments` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT 'info',
  `title` varchar(255) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_notifications_user_id_read_at_index` (`user_id`,`read_at`),
  CONSTRAINT `user_notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(50) NOT NULL,
  `level` tinyint unsigned NOT NULL DEFAULT '5',
  `parent_id` bigint unsigned DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_slug_unique` (`slug`),
  KEY `roles_parent_id_foreign` (`parent_id`),
  CONSTRAINT `roles_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `permission_role` (
  `role_id` bigint unsigned NOT NULL,
  `permission` varchar(60) NOT NULL,
  PRIMARY KEY (`role_id`,`permission`),
  CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `role_user` (
  `role_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`role_id`,`user_id`),
  KEY `role_user_user_id_foreign` (`user_id`),
  CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `user_permissions` (
  `user_id` bigint unsigned NOT NULL,
  `permission` varchar(60) NOT NULL,
  PRIMARY KEY (`user_id`,`permission`),
  CONSTRAINT `user_permissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `branch_user` (
  `branch_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`branch_id`,`user_id`),
  KEY `branch_user_user_id_foreign` (`user_id`),
  CONSTRAINT `branch_user_branch_id_foreign` FOREIGN KEY (`branch_id`) REFERENCES `branches` (`id`) ON DELETE CASCADE,
  CONSTRAINT `branch_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------- migrations records
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
  (1, '2019_08_19_000000_create_failed_jobs_table', 1),
  (2, '2020_01_01_000001_create_branches_table', 1),
  (3, '2020_01_01_000002_create_users_table', 1),
  (4, '2020_01_01_000003_create_customers_table', 1),
  (5, '2020_01_01_000004_create_couriers_table', 1),
  (6, '2020_01_01_000005_create_shipments_table', 1),
  (7, '2020_01_01_000006_create_shipment_histories_table', 1),
  (8, '2020_01_01_000007_create_invoices_table', 1),
  (9, '2020_01_01_000008_create_user_notifications_table', 1),
  (10, '2020_02_01_000001_create_roles_and_permissions_tables', 1),
  (11, '2020_02_01_000002_add_more_fields_to_shipments_table', 1),
  (12, '2020_03_01_000001_add_kind_to_invoice_items_table', 1),
  (13, '2020_03_01_000002_add_shipping_amount_to_invoice_items_table', 1);

-- ---------------------------------------------------------------- default roles and permissions
INSERT INTO `roles` (`id`, `name`, `slug`, `level`, `parent_id`, `description`, `is_system`, `created_at`, `updated_at`) VALUES
  (1, 'General manager', 'admin', 1, NULL, 'Full permissions on all branches and the system', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (2, 'Branch manager', 'branch_manager', 2, 1, 'Full management of branch operations', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (3, 'Supervisor', 'supervisor', 3, 2, 'Follows operations and assigns shipments', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (4, 'Accountant', 'accountant', 3, 2, 'Invoices and financial reports', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (5, 'Employee', 'employee', 4, 3, 'Entering shipments and customers', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (6, 'Courier', 'courier', 5, 2, 'Delivers assigned shipments and updates their status', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00');

INSERT INTO `permission_role` (`role_id`, `permission`) VALUES
  (2, 'shipments.view'),
  (2, 'shipments.create'),
  (2, 'shipments.edit'),
  (2, 'shipments.delete'),
  (2, 'shipments.assign'),
  (2, 'shipments.status'),
  (2, 'shipments.final_override'),
  (2, 'customers.view'),
  (2, 'customers.manage'),
  (2, 'customers.delete'),
  (2, 'invoices.view'),
  (2, 'invoices.create'),
  (2, 'invoices.edit'),
  (2, 'invoices.pay'),
  (2, 'invoices.delete'),
  (2, 'couriers.view'),
  (2, 'couriers.manage'),
  (2, 'reports.view'),
  (2, 'reports.export'),
  (3, 'shipments.view'),
  (3, 'shipments.create'),
  (3, 'shipments.edit'),
  (3, 'shipments.assign'),
  (3, 'shipments.status'),
  (3, 'customers.view'),
  (3, 'customers.manage'),
  (3, 'invoices.view'),
  (3, 'couriers.view'),
  (3, 'reports.view'),
  (4, 'shipments.view'),
  (4, 'customers.view'),
  (4, 'invoices.view'),
  (4, 'invoices.create'),
  (4, 'invoices.pay'),
  (4, 'reports.view'),
  (4, 'reports.export'),
  (5, 'shipments.view'),
  (5, 'shipments.create'),
  (5, 'shipments.edit'),
  (5, 'shipments.status'),
  (5, 'customers.view'),
  (5, 'customers.manage'),
  (5, 'invoices.view'),
  (5, 'invoices.create'),
  (5, 'invoices.pay'),
  (6, 'shipments.view'),
  (6, 'shipments.status'),
  (6, 'scope.own_shipments');

-- the general manager ("admin" role) has every permission automatically in the application code

-- ---------------------------------------------------------------- administrator account
INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password`, `branch_id`, `is_active`, `created_at`, `updated_at`, `work_type`) VALUES
  (1, 'General manager', 'admin@shipping.test', '01000000000', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NULL, 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00', 'hq');

INSERT INTO `role_user` (`role_id`, `user_id`) VALUES
  (1, 1);

SET FOREIGN_KEY_CHECKS = 1;
