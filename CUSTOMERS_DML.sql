ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
DELETE FROM CUSTOMERS;

-- Insert data into customers table
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (1, 'John Doe', 'john@example.com', 1234567890, '123 Main St', '101', 'City1', 'Country1', '12345');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (2, 'Jane Smith', 'jane@example.com', 9876543210, '456 Oak St', '102', 'City2', 'Country2', '67890');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (3, 'Mike Johnson', 'mike@example.com', 5551112222, '789 Maple St', '103', 'City3', 'Country3', '98765');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (4, 'Emily White', 'emily@example.com', 9998887777, '321 Pine St', '104', 'City4', 'Country4', '54321');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (5, 'Alex Brown', 'alex@example.com', 1112223333, '654 Birch St', '202', 'City5', 'Country5', '11223');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (6, 'Jessica Lee', 'jessica@example.com', 7778889999, '876 Cedar St', '130', 'City6', 'Country6', '33445');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (7, 'David Miller', 'david@example.com', 3334445555, '987 Oak St', '203', 'City7', 'Country7', '55667');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (8, 'Sophia Taylor', 'sophia@example.com', 6667778888, '123 Elm St', '303', 'City8', 'Country8', '77889');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (9, 'Daniel Wilson', 'daniel@example.com', 4445556666, '234 Pine St', '640', 'City9', 'Country9', '99001');
INSERT INTO customers (custid, name, email, contactnum, addr_street, addr_unit, city, country, zip_code) VALUES (10, 'Olivia Smith', 'olivia@example.com', 8889990000, '567 Maple St', '220', 'City10', 'Country10', '11223');

COMMIT;

SELECT * FROM CUSTOMERS;