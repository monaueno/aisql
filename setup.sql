CREATE TABLE person (
  id BIGINT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone_number VARCHAR(30),
  email VARCHAR(255)
);

CREATE TABLE customer (
  id BIGINT PRIMARY KEY REFERENCES person(id)
);

CREATE TABLE field (
  id BIGINT PRIMARY KEY,
  field VARCHAR(100)
);

CREATE TABLE location (
  location_id BIGINT PRIMARY KEY,
  street VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(50),
  zip_code VARCHAR(20)
);

CREATE TABLE salon (
  salon_id BIGINT PRIMARY KEY,
  name VARCHAR(150),
  location_id BIGINT REFERENCES location(location_id),
  phone_number VARCHAR(30)
);

CREATE TABLE beauty_professional (
  id BIGINT PRIMARY KEY REFERENCES person(id),
  field_id BIGINT REFERENCES field(id),
  salon_id BIGINT REFERENCES salon(salon_id)
);

CREATE TABLE salon_owner (
  id BIGINT PRIMARY KEY REFERENCES person(id),
  salon_id BIGINT REFERENCES salon(salon_id)
);

CREATE TABLE service (
  id BIGINT PRIMARY KEY,
  service VARCHAR(150)
);

CREATE TABLE price_list (
  beauty_professional_id BIGINT REFERENCES beauty_professional(id),
  service_id BIGINT REFERENCES service(id),
  price_cents BIGINT,
  updated_at TIMESTAMP,
  PRIMARY KEY (beauty_professional_id, service_id)
);

CREATE TABLE appointment_status (
  appointment_status_id BIGINT PRIMARY KEY,
  status VARCHAR(50)
);

CREATE TABLE appointments (
  id BIGINT PRIMARY KEY,
  beauty_professional_id BIGINT REFERENCES beauty_professional(id),
  service_id BIGINT REFERENCES service(id),
  customer_id BIGINT REFERENCES customer(id),
  salon_id BIGINT REFERENCES salon(salon_id),
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status_id BIGINT REFERENCES appointment_status(appointment_status_id),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE invoice_status (
  invoice_status_id BIGINT PRIMARY KEY,
  status VARCHAR(50)
);

CREATE TABLE invoice (
  invoice_id BIGINT PRIMARY KEY,
  appointment_id BIGINT REFERENCES appointments(id) NOT NULL UNIQUE,
  invoice_status_id BIGINT REFERENCES invoice_status(invoice_status_id),
  amount_cents BIGINT,
  platform_fee_cents BIGINT,
  currency VARCHAR(3),
  issued_at TIMESTAMP,
  due_at TIMESTAMP,
  paid_at TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

CREATE TABLE payment (
  payment_id BIGINT PRIMARY KEY,
  invoice_id BIGINT REFERENCES invoice(invoice_id),
  invoice_status_id BIGINT REFERENCES invoice_status(invoice_status_id),
  amount_cents BIGINT,
  processor VARCHAR(50),
  processor_payment_id VARCHAR(100)
);