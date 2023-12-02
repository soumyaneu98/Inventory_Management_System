-- Run this script as IMS_MANAGER
ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
set serveroutput on;

-- Inserting into categories table
-- Execute the ADD_CATEGORY procedure to insert data into the categories table
BEGIN
  ADD_CATEGORY('Laptop');
  ADD_CATEGORY('Mobile');
  ADD_CATEGORY('Tablet');
  ADD_CATEGORY('Headphone');
  ADD_CATEGORY('Speaker');
END;
/

--Execution Statement for Discounts :
 
BEGIN
  ADD_DISCOUNT('10% Off', 10);
  ADD_DISCOUNT('15% Off', 15);
  ADD_DISCOUNT('20% Off', 20);
  ADD_DISCOUNT('25% Off', 25);
  ADD_DISCOUNT('30% Off', 30);
  ADD_DISCOUNT('5% Off', 5);
  ADD_DISCOUNT('12% Off', 12);
  ADD_DISCOUNT('18% Off', 18);
  ADD_DISCOUNT('8% Off', 8);
  ADD_DISCOUNT('22% Off', 22);
END;
/

BEGIN
-- Laptops

ADD_PRODUCT('Ultra-Slim Laptop', 'Sleek and lightweight laptop for on-the-go productivity', 1500.00, 60, 24, 'Apple Inc', 'Laptop', '10% Off');
ADD_PRODUCT('Gaming Laptop', 'High-performance gaming laptop for an immersive gaming experience', 2000.00, 70, 24, 'Apple Inc', 'Laptop', '15% Off');
ADD_PRODUCT('Convertible Laptop', 'Flexible design for both laptop and tablet use', 1200.00, 80, 24, 'Samsung Electronics', 'Laptop', '15% Off');
ADD_PRODUCT('Business Ultrabook', 'Powerful and lightweight laptop for professional use', 1800.00, 90, 24, 'Samsung Electronics', 'Laptop', '20% Off');
ADD_PRODUCT('Budget Chromebook', 'Affordable laptop with Chrome OS for everyday tasks', 400.00, 100, 12, 'OnePlus Technology', 'Laptop', '25% Off');
ADD_PRODUCT('High-Performance Workstation', 'Designed for intensive computing and professional applications', 2500.00, 110, 36, 'OnePlus Technology', 'Laptop', '30% Off');

-- Speakers
ADD_PRODUCT('Wireless Bluetooth Speaker', 'Connectivity and portability in one: Enjoy music wirelessly', 80.00, 120, 18, 'Xiaomi Corporation', 'Speaker', '15% Off');
ADD_PRODUCT('Surround Sound Speaker System', 'Immerse yourself in 360-degree sound with this speaker system', 300.00, 130, 24, 'Xiaomi Corporation', 'Speaker', '20% Off');
ADD_PRODUCT('Smart Home Speaker', 'Voice-activated speaker with smart home integration', 120.00, 140, 12, 'Xiaomi Corporation', 'Speaker', '20% Off');
ADD_PRODUCT('Portable Outdoor Speaker', 'Durable and waterproof speaker for outdoor adventures', 90.00, 150, 18, 'Xiaomi Corporation', 'Speaker', '25% Off');
ADD_PRODUCT('Bookshelf Stereo System', 'High-quality audio system for your home entertainment', 300.00, 160, 24, 'Lenovo Group Ltd', 'Speaker', '20% Off');
ADD_PRODUCT('Wireless Surround Sound Bar', 'Enhance your TV audio with a wireless surround sound bar', 200.00, 170, 24, 'Lenovo Group Ltd', 'Speaker', '25% Off');

-- Mobile
ADD_PRODUCT('Budget-Friendly Smartphone', 'Affordable smartphone with essential features', 300.00, 180, 12, 'Xiaomi Corporation', 'Mobile', '10% Off');
ADD_PRODUCT('Camera-Centric Mobile', 'Capture stunning moments with the advanced camera features', 500.00, 190, 8, 'Xiaomi Corporation', 'Mobile', '15% Off');
ADD_PRODUCT('Flagship Smartphone', 'Top-of-the-line smartphone with cutting-edge features', 1000.00, 200, 8, 'OnePlus Technology', 'Mobile', '15% Off');
ADD_PRODUCT('Foldable Android Phone', 'Innovative foldable design for a unique mobile experience', 1500.00, 210, 10, 'OnePlus Technology', 'Mobile', '20% Off');
ADD_PRODUCT('Budget Gaming Smartphone', 'Affordable smartphone optimized for gaming performance', 500.00, 60, 6, 'Samsung Electronics', 'Mobile', '25% Off');
ADD_PRODUCT('Camera Pro Mobile', 'Professional-grade camera features for photography enthusiasts', 800.00, 60, 6, 'Samsung Electronics', 'Mobile', '30% Off');

-- Headphone
ADD_PRODUCT('Wireless Over-Ear Headphones', 'Immersive audio experience with wireless convenience', 120.00, 70, 6, 'Apple Inc', 'Headphone', '25% Off');
ADD_PRODUCT('Sports In-Ear Headphones', 'Designed for active lifestyles with sweat-resistant technology', 50.00, 80, 6, 'Apple Inc', 'Headphone', '30% Off');
ADD_PRODUCT('Wireless Noise-Canceling Headphones', 'Immersive audio experience with noise-canceling technology', 150.00, 90, 24, 'Lenovo Group Ltd', 'Headphone', '15% Off');
ADD_PRODUCT('Bluetooth Sports Earbuds', 'Sweat-proof earbuds designed for an active lifestyle', 80.00, 100, 24, 'Lenovo Group Ltd', 'Headphone', '20% Off');
ADD_PRODUCT('High-Fidelity Over-Ear Headphones', 'Premium over-ear headphones for audiophiles', 200.00, 110, 24, 'Xiaomi Corporation', 'Headphone', '20% Off');
ADD_PRODUCT('Gaming Headset with Mic', 'Immersive gaming experience with built-in microphone', 120.00, 120, 24, 'Xiaomi Corporation', 'Headphone', '25% Off');

-- Tablets
ADD_PRODUCT('Convertible Tablet/Laptop', 'Versatile 2-in-1 device for work and play', 800.00, 130, 24, 'Lenovo Group Ltd', 'Tablet', '20% Off');
ADD_PRODUCT('Kids Educational Tablet', 'Interactive and educational tablet for children', 100.00, 140, 24, 'Lenovo Group Ltd', 'Tablet', '25% Off');
ADD_PRODUCT('High-Performance Android Tablet', 'Powerful Android tablet for productivity and entertainment', 600.00, 150, 24, 'OnePlus Technology', 'Tablet', '15% Off');
ADD_PRODUCT('Kid-Friendly Learning Tablet', 'Educational tablet designed for children with parental controls', 80.00, 160, 24, 'OnePlus Technology', 'Tablet', '20% Off');
ADD_PRODUCT('Windows Convertible Tablet', 'Versatile tablet with Windows OS for work and creativity', 900.00, 170, 24, 'Samsung Electronics', 'Tablet', '25% Off');
ADD_PRODUCT('Large Screen Entertainment Tablet', 'Tablet with a large display for immersive multimedia experience', 400.00, 180, 24, 'Samsung Electronics', 'Tablet', '30% Off');
end;
/



