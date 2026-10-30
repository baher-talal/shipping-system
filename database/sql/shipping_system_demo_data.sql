-- ============================================================================
-- Shipping Management System - DEMO DATA (optional)
-- Import AFTER shipping_system.sql. All demo accounts use the password:  password
--
--   manager@shipping.test   Cairo branch manager
--   employee@shipping.test  Cairo employee
--   alex@shipping.test      Alexandria branch manager
--   courier@shipping.test   Courier (Cairo)
--
-- Do not import this file on a production database.
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO `branches` (`id`, `name`, `code`, `city`, `address`, `phone`, `is_active`, `created_at`, `updated_at`) VALUES
  (1, 'Cairo Branch', 'CAI', 'Cairo', 'Nasr City - Makram Ebeid St.', '0222000001', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (2, 'Alexandria Branch', 'ALX', 'Alexandria', 'Smouha', '0333000001', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00');

INSERT INTO `users` (`id`, `name`, `email`, `phone`, `password`, `branch_id`, `is_active`, `created_at`, `updated_at`, `work_type`) VALUES
  (2, 'Cairo Branch Manager', 'manager@shipping.test', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00', 'branch'),
  (3, 'Cairo Employee', 'employee@shipping.test', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00', 'branch'),
  (4, 'Alexandria Branch Manager', 'alex@shipping.test', NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 2, 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00', 'branch'),
  (5, 'Ahmed (Courier)', 'courier@shipping.test', '01011111111', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 1, 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00', 'branch');

INSERT INTO `role_user` (`role_id`, `user_id`) VALUES
  (2, 2),
  (5, 3),
  (2, 4),
  (6, 5);

INSERT INTO `branch_user` (`branch_id`, `user_id`) VALUES
  (1, 2),
  (1, 3),
  (2, 4),
  (1, 5);

INSERT INTO `couriers` (`id`, `branch_id`, `user_id`, `name`, `phone`, `vehicle_type`, `vehicle_number`, `status`, `is_active`, `created_at`, `updated_at`) VALUES
  (1, 1, 5, 'Ahmed (Courier)', '01011111111', 'motorcycle', 'Q A 1234', 'available', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (2, 1, NULL, 'Mahmoud Ali', '01022222222', 'van', 'B G 5678', 'available', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00');

INSERT INTO `customers` (`id`, `branch_id`, `name`, `company`, `phone`, `email`, `city`, `address`, `is_active`, `created_at`, `updated_at`) VALUES
  (1, 1, 'Nile Trading Co.', 'Nile Trading', '01033333333', 'info@nile.test', 'Cairo', 'Downtown', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (2, 1, 'Sara Mohamed', NULL, '01044444444', NULL, 'Giza', 'Dokki', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00'),
  (3, 1, 'Al Amal Store', 'Al Amal Store', '01055555555', NULL, 'Cairo', 'Nasr City', 1, '2026-10-28 10:00:00', '2026-10-28 10:00:00');

INSERT INTO `shipments` (`id`, `tracking_number`, `branch_id`, `customer_id`, `courier_id`, `created_by`, `origin_city`, `receiver_name`, `receiver_phone`, `receiver_city`, `receiver_address`, `service_type`, `weight`, `pieces`, `description`, `shipping_cost`, `payment_method`, `cod_amount`, `status`, `expected_delivery`, `delivered_at`, `created_at`, `updated_at`, `pickup_type`, `package_type`, `is_fragile`, `allow_open`, `goods_value`, `total_amount`, `shipping_payer`) VALUES
  (1, 'SH2610276GO909', 1, 1, NULL, 3, 'Cairo', 'Receiver #1', '01069236009', 'Alexandria', 'Street 10, Building 1', 'standard', 9.5, 4, 'Assorted parcel', 121, 'cod', 1350, 'pending', '2026-10-31', NULL, '2026-10-27 10:00:00', '2026-10-27 10:00:00', 'pickup', 'parcel', 0, 0, 1229, 1350, 'receiver'),
  (2, 'SH261025FHSG2A', 1, 2, 1, 3, 'Cairo', 'Receiver #2', '01069225646', 'Aswan', 'Street 11, Building 2', 'express', 5.5, 2, 'Assorted parcel', 40, 'prepaid', 0, 'picked_up', '2026-10-27', NULL, '2026-10-25 10:00:00', '2026-10-25 10:00:00', 'pickup', 'parcel', 0, 0, 0, 40, 'sender'),
  (3, 'SH261022WY6EVF', 1, 3, 2, 3, 'Cairo', 'Receiver #3', '01065900991', 'Mansoura', 'Street 12, Building 3', 'same_day', 5.0, 4, 'Assorted parcel', 104, 'cod', 912, 'in_transit', '2026-10-22', NULL, '2026-10-22 10:00:00', '2026-10-22 10:00:00', 'pickup', 'parcel', 0, 0, 912, 1016, 'sender'),
  (4, 'SH261026TBXX31', 1, 1, 1, 3, 'Cairo', 'Receiver #4', '01062521428', 'Tanta', 'Street 13, Building 4', 'standard', 6.5, 4, 'Assorted parcel', 187, 'prepaid', 0, 'out_for_delivery', '2026-10-30', NULL, '2026-10-26 10:00:00', '2026-10-26 10:00:00', 'pickup', 'parcel', 0, 0, 0, 187, 'sender'),
  (5, 'SH2610275Z7Q04', 1, 2, 2, 3, 'Cairo', 'Receiver #5', '01069605863', 'Luxor', 'Street 14, Building 5', 'express', 8.5, 1, 'Assorted parcel', 148, 'cod', 1385, 'delivered', '2026-10-29', '2026-10-28 10:00:00', '2026-10-27 10:00:00', '2026-10-27 10:00:00', 'pickup', 'parcel', 0, 0, 1237, 1385, 'receiver'),
  (6, 'SH261019ID7G14', 1, 3, 1, 3, 'Cairo', 'Receiver #6', '01063389286', 'Port Said', 'Street 15, Building 6', 'same_day', 8.0, 2, 'Assorted parcel', 97, 'prepaid', 0, 'delivered', '2026-10-19', '2026-10-20 10:00:00', '2026-10-19 10:00:00', '2026-10-19 10:00:00', 'pickup', 'parcel', 0, 0, 0, 97, 'sender'),
  (7, 'SH26102748Q9ZT', 1, 1, 2, 3, 'Cairo', 'Receiver #7', '01069420478', 'Alexandria', 'Street 16, Building 7', 'standard', 8.0, 4, 'Assorted parcel', 200, 'cod', 1135, 'returned', '2026-10-31', NULL, '2026-10-27 10:00:00', '2026-10-27 10:00:00', 'pickup', 'parcel', 0, 0, 1135, 1335, 'sender'),
  (8, 'SH261022SRACJ3', 1, 2, NULL, 3, 'Cairo', 'Receiver #8', '01069772618', 'Aswan', 'Street 17, Building 8', 'express', 8.0, 3, 'Assorted parcel', 91, 'prepaid', 0, 'pending', '2026-10-24', NULL, '2026-10-22 10:00:00', '2026-10-22 10:00:00', 'pickup', 'parcel', 0, 0, 0, 91, 'sender'),
  (9, 'SH26102536519C', 1, 3, 2, 3, 'Cairo', 'Receiver #9', '01065866552', 'Mansoura', 'Street 18, Building 9', 'same_day', 5.5, 4, 'Assorted parcel', 106, 'cod', 1300, 'picked_up', '2026-10-25', NULL, '2026-10-25 10:00:00', '2026-10-25 10:00:00', 'pickup', 'parcel', 0, 0, 1194, 1300, 'receiver'),
  (10, 'SH26101626Q2L1', 1, 1, 1, 3, 'Cairo', 'Receiver #10', '01069038740', 'Tanta', 'Street 19, Building 10', 'standard', 1.5, 3, 'Assorted parcel', 65, 'prepaid', 0, 'in_transit', '2026-10-20', NULL, '2026-10-16 10:00:00', '2026-10-16 10:00:00', 'pickup', 'parcel', 0, 0, 0, 65, 'sender'),
  (11, 'SH261021M0J2AF', 1, 2, 2, 3, 'Cairo', 'Receiver #11', '01061003589', 'Luxor', 'Street 20, Building 11', 'express', 7.5, 1, 'Assorted parcel', 134, 'cod', 397, 'out_for_delivery', '2026-10-23', NULL, '2026-10-21 10:00:00', '2026-10-21 10:00:00', 'pickup', 'parcel', 0, 0, 397, 531, 'sender'),
  (12, 'SH261019PHC8RW', 1, 3, 1, 3, 'Cairo', 'Receiver #12', '01063596457', 'Port Said', 'Street 21, Building 12', 'same_day', 0.5, 3, 'Assorted parcel', 90, 'prepaid', 0, 'delivered', '2026-10-19', '2026-10-20 10:00:00', '2026-10-19 10:00:00', '2026-10-19 10:00:00', 'pickup', 'parcel', 0, 0, 0, 90, 'sender'),
  (13, 'SH2610185I8O4I', 1, 1, 2, 3, 'Cairo', 'Receiver #13', '01069467819', 'Alexandria', 'Street 22, Building 13', 'standard', 5.0, 1, 'Assorted parcel', 189, 'cod', 1565, 'delivered', '2026-10-22', '2026-10-19 10:00:00', '2026-10-18 10:00:00', '2026-10-18 10:00:00', 'pickup', 'parcel', 0, 0, 1376, 1565, 'receiver'),
  (14, 'SH261022IT60YJ', 1, 2, 1, 3, 'Cairo', 'Receiver #14', '01069724671', 'Aswan', 'Street 23, Building 14', 'express', 3.5, 4, 'Assorted parcel', 80, 'prepaid', 0, 'returned', '2026-10-24', NULL, '2026-10-22 10:00:00', '2026-10-22 10:00:00', 'pickup', 'parcel', 0, 0, 0, 80, 'sender');

INSERT INTO `shipment_histories` (`id`, `shipment_id`, `user_id`, `status`, `location`, `note`, `created_at`, `updated_at`) VALUES
  (1, 1, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-27 10:00:00', '2026-10-27 10:00:00'),
  (2, 2, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-25 10:00:00', '2026-10-25 10:00:00'),
  (3, 2, 2, 'picked_up', NULL, 'Demo update', '2026-10-25 15:00:00', '2026-10-25 15:00:00'),
  (4, 3, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-22 10:00:00', '2026-10-22 10:00:00'),
  (5, 3, 2, 'in_transit', NULL, 'Demo update', '2026-10-22 15:00:00', '2026-10-22 15:00:00'),
  (6, 4, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-26 10:00:00', '2026-10-26 10:00:00'),
  (7, 4, 2, 'out_for_delivery', NULL, 'Demo update', '2026-10-26 15:00:00', '2026-10-26 15:00:00'),
  (8, 5, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-27 10:00:00', '2026-10-27 10:00:00'),
  (9, 5, 2, 'delivered', NULL, 'Demo update', '2026-10-27 15:00:00', '2026-10-27 15:00:00'),
  (10, 6, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-19 10:00:00', '2026-10-19 10:00:00'),
  (11, 6, 2, 'delivered', NULL, 'Demo update', '2026-10-19 15:00:00', '2026-10-19 15:00:00'),
  (12, 7, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-27 10:00:00', '2026-10-27 10:00:00'),
  (13, 7, 2, 'returned', NULL, 'Demo update', '2026-10-27 15:00:00', '2026-10-27 15:00:00'),
  (14, 8, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-22 10:00:00', '2026-10-22 10:00:00'),
  (15, 9, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-25 10:00:00', '2026-10-25 10:00:00'),
  (16, 9, 2, 'picked_up', NULL, 'Demo update', '2026-10-25 15:00:00', '2026-10-25 15:00:00'),
  (17, 10, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-16 10:00:00', '2026-10-16 10:00:00'),
  (18, 10, 2, 'in_transit', NULL, 'Demo update', '2026-10-16 15:00:00', '2026-10-16 15:00:00'),
  (19, 11, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-21 10:00:00', '2026-10-21 10:00:00'),
  (20, 11, 2, 'out_for_delivery', NULL, 'Demo update', '2026-10-21 15:00:00', '2026-10-21 15:00:00'),
  (21, 12, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-19 10:00:00', '2026-10-19 10:00:00'),
  (22, 12, 2, 'delivered', NULL, 'Demo update', '2026-10-19 15:00:00', '2026-10-19 15:00:00'),
  (23, 13, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-18 10:00:00', '2026-10-18 10:00:00'),
  (24, 13, 2, 'delivered', NULL, 'Demo update', '2026-10-18 15:00:00', '2026-10-18 15:00:00'),
  (25, 14, 3, 'pending', 'Cairo', 'Shipment created', '2026-10-22 10:00:00', '2026-10-22 10:00:00'),
  (26, 14, 2, 'returned', NULL, 'Demo update', '2026-10-22 15:00:00', '2026-10-22 15:00:00');

SET FOREIGN_KEY_CHECKS = 1;
