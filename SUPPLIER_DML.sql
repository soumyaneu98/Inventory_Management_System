ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
DELETE FROM SUPPLIERS;

-- Insert data into suppliers table
INSERT INTO suppliers (supid, name, email, contactnum, addr_street, website, itin, addr_unit, city, country, zip_code) VALUES
(suppliers_seq.NEXTVAL, 'Supplier1', 'supp1@example.com', 1234567890, '789 Elm St', '
www.supplier1.com'
, 'ITIN123', 101, 'City1', 'Country1', '54321');
INSERT INTO suppliers (supid, name, email, contactnum, addr_street, website, itin, addr_unit, city, country, zip_code) VALUES
(suppliers_seq.NEXTVAL, 'Supplier2', 'supp2@example.com', 9876543210, '321 Pine St', '
www.supplier2.com'
, 'ITIN456', 102, 'City2', 'Country2', '98765');
INSERT INTO suppliers (supid, name, email, contactnum, addr_street, website, itin, addr_unit, city, country, zip_code) VALUES
(suppliers_seq.NEXTVAL, 'Supplier3', 'supp3@example.com', 5554443333, '456 Oak St', '
www.supplier3.com'
, 'ITIN789', 103, 'City3', 'Country3', '11223');
INSERT INTO suppliers (supid, name, email, contactnum, addr_street, website, itin, addr_unit, city, country, zip_code) VALUES
(suppliers_seq.NEXTVAL, 'Supplier4', 'supp4@example.com', 1112223333, '654 Birch St', '
www.supplier4.com'
, 'ITIN987', 104, 'City4', 'Country4', '33445');
INSERT INTO suppliers (supid, name, email, contactnum, addr_street, website, itin, addr_unit, city, country, zip_code) VALUES
(suppliers_seq.NEXTVAL, 'Supplier5', 'supp5@example.com', 6665554444, '789 Cedar St', '
www.supplier5.com'
, 'ITIN654', 105, 'City5', 'Country5', '55667');
COMMIT;


SELECT * FROM SUPPLIERS;