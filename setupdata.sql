INSERT INTO location (location_id, street, city, state, zip_code) VALUES
(1, '120 Center St', 'Provo', 'UT', '84601'),
(2, '455 Main St', 'Orem', 'UT', '84057');

INSERT INTO salon (salon_id, name, location_id, phone_number) VALUES
(1, 'Glow Studio', 1, '801-555-0101'),
(2, 'Velvet Spa', 2, '801-555-0102');

INSERT INTO field (id, field) VALUES
(1, 'Esthetics'),
(2, 'Nails');

INSERT INTO person (id, first_name, last_name, phone_number, email) VALUES
(1, 'Ana', 'Lopez', '801-555-0201', 'ana@example.com'),
(2, 'Ben', 'Carter', '801-555-0202', 'ben@example.com'),
(3, 'Chloe', 'Kim', '801-555-0203', 'chloe@example.com'),
(4, 'Dan', 'Reyes', '801-555-0204', 'dan@example.com'),
(5, 'Emma', 'Wu', '801-555-0205', 'emma@example.com');

INSERT INTO beauty_professional (id, field_id, salon_id) VALUES
(1, 1, 1),
(2, 2, 2);

INSERT INTO salon_owner (id, salon_id) VALUES
(3, 1),
(4, 2);

INSERT INTO customer (id) VALUES
(5);

INSERT INTO service (id, service) VALUES
(1, 'Facial'),
(2, 'Chemical Peel'),
(3, 'Manicure');

INSERT INTO price_list (beauty_professional_id, service_id, price_cents, updated_at) VALUES
(1, 1, 8000, '2026-10-01 09:00:00'),
(1, 2, 12000, '2026-10-01 09:00:00'),
(2, 3, 4500, '2026-10-01 09:00:00');

INSERT INTO appointment_status (appointment_status_id, status) VALUES
(1, 'booked'),
(2, 'completed'),
(3, 'cancelled');

INSERT INTO appointments (id, beauty_professional_id, service_id, customer_id, salon_id, start_time, end_time, status_id, created_at, updated_at) VALUES
(1, 1, 1, 5, 1, '2026-10-10 10:00:00', '2026-10-10 11:00:00', 2, '2026-10-05 12:00:00', '2026-10-10 11:05:00'),
(2, 1, 2, 5, 1, '2026-10-20 14:00:00', '2026-10-20 15:00:00', 1, '2026-10-12 08:00:00', '2026-10-12 08:00:00'),
(3, 2, 3, 5, 2, '2026-10-11 13:00:00', '2026-10-11 13:30:00', 3, '2026-10-08 09:00:00', '2026-10-09 16:00:00');

INSERT INTO invoice_status (invoice_status_id, status) VALUES
(1, 'open'),
(2, 'paid'),
(3, 'void');

INSERT INTO invoice (invoice_id, appointment_id, invoice_status_id, amount_cents, platform_fee_cents, currency, issued_at, due_at, paid_at, created_at, updated_at) VALUES
(1, 1, 2, 8000, 240, 'USD', '2026-10-10 11:05:00', '2026-10-17 23:59:59', '2026-10-10 11:20:00', '2026-10-10 11:05:00', '2026-10-10 11:20:00'),
(2, 2, 1, 12000, 360, 'USD', '2026-10-12 08:00:00', '2026-10-27 23:59:59', NULL, '2026-10-12 08:00:00', '2026-10-12 08:00:00');

INSERT INTO payment (payment_id, invoice_id, invoice_status_id, amount_cents, processor, processor_payment_id) VALUES
(1, 1, 2, 8000, 'stripe', 'pi_test_001');