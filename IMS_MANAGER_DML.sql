ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
DELETE FROM categories;
-- Insert data into categories table
INSERT INTO categories (ctgryid, name) VALUES
(categories_seq.NEXTVAL, 'Laptop');
INSERT INTO categories (ctgryid, name) VALUES
(categories_seq.NEXTVAL, 'Mobile');
INSERT INTO categories (ctgryid, name) VALUES
(categories_seq.NEXTVAL, 'Tablet ');
INSERT INTO categories (ctgryid, name) VALUES
(categories_seq.NEXTVAL, 'Headphone');
INSERT INTO categories (ctgryid, name) VALUES
(categories_seq.NEXTVAL, 'Speaker');
COMMIT;
SELECT * FROM categories;