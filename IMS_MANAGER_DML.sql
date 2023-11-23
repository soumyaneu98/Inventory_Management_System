ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;

DELETE FROM PRODUCTORDER;
DELETE FROM PRODUCTSUPPLY;
DELETE FROM ORDERS;
DELETE FROM PRODUCTS;
DELETE FROM categories;
DELETE FROM DISCOUNTS;


-- Inserting into categories table
INSERT INTO categories (ctgryid, name) VALUES (1, 'Laptop');
INSERT INTO categories (ctgryid, name) VALUES (2, 'Mobile');
INSERT INTO categories (ctgryid, name) VALUES (3, 'Tablet');
INSERT INTO categories (ctgryid, name) VALUES (4, 'Headphone');
INSERT INTO categories (ctgryid, name) VALUES (5, 'Speaker');

-- Insert data into discounts table without using sequence
INSERT INTO discounts (discid, value, name) VALUES (1, 10, '10% Off');
INSERT INTO discounts (discid, value, name) VALUES (2, 15, '15% Off');
INSERT INTO discounts (discid, value, name) VALUES (3, 20, '20% Off');
INSERT INTO discounts (discid, value, name) VALUES (4, 25, '25% Off');
INSERT INTO discounts (discid, value, name) VALUES (5, 30, '30% Off');
INSERT INTO discounts (discid, value, name) VALUES (6, 5, '5% Off');
INSERT INTO discounts (discid, value, name) VALUES (7, 12, '12% Off');
INSERT INTO discounts (discid, value, name) VALUES (8, 18, '18% Off');
INSERT INTO discounts (discid, value, name) VALUES (9, 8, '8% Off');
INSERT INTO discounts (discid, value, name) VALUES (10, 22, '22% Off');

-- Inserting into products table
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(1, 'Ultra-Slim Laptop', 'Sleek and lightweight laptop for on-the-go productivity', 1500.00, 30, 3, 'Y', 24, 1, 1, 10, null);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(2, 'Gaming Laptop', 'High-performance gaming laptop for an immersive gaming experience', 2000.00, 20, 2, 'Y', 24, 1, 1, 15, 2);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(3, 'Convertible Laptop', 'Flexible design for both laptop and tablet use', 1200.00, 25, 3, 'Y', 24, 2, 1, 8, 2);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(4, 'Business Ultrabook', 'Powerful and lightweight laptop for professional use', 1800.00, 15, 2, 'Y', 24, 2, 1, 12, 3);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(5, 'Budget Chromebook', 'Affordable laptop with Chrome OS for everyday tasks', 400.00, 50, 5, 'Y', 12, 3, 1, 15, 4);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(6, 'High-Performance Workstation', 'Designed for intensive computing and professional applications', 2500.00, 10, 1, 'Y', 36, 3, 1, 10, 5);
 
-- Speaker
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(7, 'Wireless Bluetooth Speaker', 'Connectivity and portability in one: Enjoy music wirelessly', 80.00, 50, 5, 'Y', 18, 2, 5, 12, 2);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(8, 'Surround Sound Speaker System', 'Immerse yourself in 360-degree sound with this speaker system', 300.00, 15, 2, 'Y', 24, 2, 5, 8, 3);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(9, 'Smart Home Speaker', 'Voice-activated speaker with smart home integration', 120.00, 40, 4, 'Y', 12, 1, 5, 8, 3);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(10, 'Portable Outdoor Speaker', 'Durable and waterproof speaker for outdoor adventures', 90.00, 30, 3, 'Y', 18, 1, 5, 10, 4);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(11, 'Bookshelf Stereo System', 'High-quality audio system for your home entertainment', 300.00, 15, 2, 'Y', 24, 4, 5, 12, 5);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(12, 'Wireless Surround Sound Bar', 'Enhance your TV audio with a wireless surround sound bar', 200.00, 20, 2, 'Y', 24, 4, 5, 15, 6);
 
-- Mobile
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(13, 'Budget-Friendly Smartphone', 'Affordable smartphone with essential features', 300.00, 80, 8, 'Y', 12, 5, 2, 10, 4);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(14, 'Camera-Centric Mobile', 'Capture stunning moments with the advanced camera features', 500.00, 40, 4, 'Y', 12, 5, 2, 8, 5);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(15, 'Flagship Smartphone', 'Top-of-the-line smartphone with cutting-edge features', 1000.00, 20, 2, 'Y', 24, 3, 2, 8, 4);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(16, 'Foldable Android Phone', 'Innovative foldable design for a unique mobile experience', 1500.00, 15, 2, 'Y', 24, 3, 2, 10, 5);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(17, 'Budget Gaming Smartphone', 'Affordable smartphone optimized for gaming performance', 500.00, 30, 3, 'Y', 12, 2, 2, 12, 6);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(18, 'Camera Pro Mobile', 'Professional-grade camera features for photography enthusiasts', 800.00, 25, 3, 'Y', 18, 2, 2, 15, 7);
 
-- Headphone
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(19, 'Wireless Over-Ear Headphones', 'Immersive audio experience with wireless convenience', 120.00, 25, 3, 'Y', 12, 1, 4, 5, 6);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(20, 'Sports In-Ear Headphones', 'Designed for active lifestyles with sweat-resistant technology', 50.00, 60, 6, 'Y', 6, 1, 4, 15, 7);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(21, 'Wireless Noise-Canceling Headphones', 'Immersive audio experience with noise-canceling technology', 150.00, 25, 3, 'Y', 12, 4, 4, 8, 5);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(22, 'Bluetooth Sports Earbuds', 'Sweat-proof earbuds designed for an active lifestyle', 80.00, 40, 4, 'Y', 6, 4, 4, 10, 6);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(23, 'High-Fidelity Over-Ear Headphones', 'Premium over-ear headphones for audiophiles', 200.00, 20, 2, 'Y', 24, 5, 4, 12, 7);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(24, 'Gaming Headset with Mic', 'Immersive gaming experience with built-in microphone', 120.00, 30, 3, 'Y', 12, 5, 4, 15, 8);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(25, 'Convertible Tablet/Laptop', 'Versatile 2-in-1 device for work and play', 800.00, 35, 4, 'Y', 24, 4, 3, 10, 8);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(26, 'Kids Educational Tablet', 'Interactive and educational tablet for children', 100.00, 50, 5, 'Y', 12, 4, 3, 12, 9);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(27, 'High-Performance Android Tablet', 'Powerful Android tablet for productivity and entertainment', 600.00, 25, 3, 'Y', 24, 3, 3, 8, 4);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(28, 'Kid-Friendly Learning Tablet', 'Educational tablet designed for children with parental controls', 80.00, 50, 5, 'Y', 12, 3, 3, 10, 5);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(29, 'Windows Convertible Tablet', 'Versatile tablet with Windows OS for work and creativity', 900.00, 20, 2, 'Y', 24, 2, 3, 12, 6);
 
INSERT INTO products (prodid, name, description, price, qtyinstock, minqty, availstatus, warranty, supid, ctgryid, reorderqty, discid) VALUES
(30, 'Large Screen Entertainment Tablet', 'Tablet with a large display for immersive multimedia experience', 400.00, 30, 3, 'Y', 18, 2, 3, 15, 7);


-- Insert data into productsupply table
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(1, TO_DATE('2023-11-22', 'YYYY-MM-DD'), 1, 'Y', TO_DATE('2023-11-23', 'YYYY-MM-DD'), 45.00);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(2, TO_DATE('2023-11-23', 'YYYY-MM-DD'), 2, 'N', NULL, 60.75);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(3, TO_DATE('2023-11-24', 'YYYY-MM-DD'), 3, 'N', TO_DATE('2023-11-28', 'YYYY-MM-DD'), 80.00);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(4, TO_DATE('2023-11-25', 'YYYY-MM-DD'), 4, 'Y', TO_DATE('2023-11-30', 'YYYY-MM-DD'), 55.50);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(5, TO_DATE('2023-11-26', 'YYYY-MM-DD'), 5, 'Y', NULL, 70.25);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(6, TO_DATE('2023-11-27', 'YYYY-MM-DD'), 6, 'Y', TO_DATE('2023-11-30', 'YYYY-MM-DD'), 90.00);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(7, TO_DATE('2023-11-28', 'YYYY-MM-DD'), 7, 'N', TO_DATE('2023-12-01', 'YYYY-MM-DD'), 120.00);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(8, TO_DATE('2023-11-29', 'YYYY-MM-DD'), 8, 'Y', NULL, 100.50);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(9, TO_DATE('2023-11-30', 'YYYY-MM-DD'), 9, 'N', TO_DATE('2023-12-03', 'YYYY-MM-DD'), 70.00);
 
INSERT INTO productsupply (productsupply_id, orderdate, prodid, status, refil_date, price) VALUES
(10, TO_DATE('2023-12-01', 'YYYY-MM-DD'), 10, 'Y', TO_DATE('2023-12-05', 'YYYY-MM-DD'), 85.75);


-- Insert data into orders table
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (1, TO_DATE('2023-11-22', 'YYYY-MM-DD'), 100.00, 'Shipped', TO_DATE('2023-11-29', 'YYYY-MM-DD'), 1);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (2, TO_DATE('2023-11-23', 'YYYY-MM-DD'), 150.50, 'Processing', TO_DATE('2023-11-30', 'YYYY-MM-DD'), 2);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (3, TO_DATE('2023-11-24', 'YYYY-MM-DD'), 200.00, 'Delivered', TO_DATE('2023-12-01', 'YYYY-MM-DD'), 3);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (4, TO_DATE('2023-11-25', 'YYYY-MM-DD'), 75.25, 'Shipped', TO_DATE('2023-12-02', 'YYYY-MM-DD'), 4);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (5, TO_DATE('2023-11-26', 'YYYY-MM-DD'), 120.75, 'Processing', TO_DATE('2023-12-03', 'YYYY-MM-DD'), 5);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (6, TO_DATE('2023-11-27', 'YYYY-MM-DD'), 80.50, 'Processing', TO_DATE('2023-12-04', 'YYYY-MM-DD'), 6);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (7, TO_DATE('2023-11-28', 'YYYY-MM-DD'), 90.20, 'Delivered', TO_DATE('2023-12-05', 'YYYY-MM-DD'), 10);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (8, TO_DATE('2023-11-29', 'YYYY-MM-DD'), 110.00, 'Shipped', TO_DATE('2023-12-06', 'YYYY-MM-DD'), 7);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (9, TO_DATE('2023-11-30', 'YYYY-MM-DD'), 180.50, 'Processing', TO_DATE('2023-12-07', 'YYYY-MM-DD'), 8);
 
INSERT INTO orders (orderid, orderdate, billamt, shipstatus, dlvrydate, custid)
VALUES (10, TO_DATE('2023-12-01', 'YYYY-MM-DD'), 95.75, 'Processing', TO_DATE('2023-12-08', 'YYYY-MM-DD'), 9);


-- Insert data into productorder table
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(1, 1, 5, 250.00, 1);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(2, 2, 3, 226.50, 2);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(3, 3, 2, 180.00, 3);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(4, 4, 1, 120.00, 4);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(5, 5, 4, 200.00, 5);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(6, 6, 3, 225.00, 6);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(7, 7, 2, 160.00, 7);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(8, 8, 6, 480.00, 8);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(9, 9, 1, 50.00, 9);
 
INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id) VALUES
(10, 10, 3, 240.00, 10);

COMMIT;
SELECT * FROM CATEGORIES;
SELECT * FROM DISCOUNTS;
SELECT * FROM PRODUCTS;
SELECT * FROM PRODUCTSUPPLY;
SELECT * FROM ORDERS;
SELECT * FROM PRODUCTORDER;

