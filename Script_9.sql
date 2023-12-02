-- Run this script as customer
ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
SET SERVEROUTPUT ON;

BEGIN
    get_Customer_Order_History_View('john@example.com'); 
END;
/
SELECT * FROM Customer_Order_History_View;
 
BEGIN
    get_Customer_Order_History_View('jane@example.com'); 
END;
/
SELECT * FROM Customer_Order_History_View;
 
BEGIN
    get_Customer_Order_History_View('mike@example.com'); 
END;
/
SELECT * FROM Customer_Order_History_View;
 
BEGIN
    get_Customer_Order_History_View('emily@example.com'); 
END;
/
SELECT * FROM Customer_Order_History_View;
 
BEGIN
    get_Customer_Order_History_View('alex@example.com'); 
END;
/
SELECT * FROM Customer_Order_History_View;


SELECT * FROM customer_product_view;