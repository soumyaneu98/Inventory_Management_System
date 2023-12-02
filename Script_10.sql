ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
SET SERVEROUTPUT ON;

BEGIN
    get_supplier_product_performance_view('apple@example.com'); 
END;
/
SELECT * FROM Supplier_Product_Performance_View;
 
 
BEGIN
    get_supplier_product_performance_view('samsung@example.com'); 
END;
/
SELECT * FROM Supplier_Product_Performance_View;
 
 
BEGIN
    get_supplier_product_performance_view('oneplus@example.com'); 
END;
/
SELECT * FROM Supplier_Product_Performance_View;
 
BEGIN
    get_supplier_product_performance_view('xiaomi@example.com'); 
END;
/
SELECT * FROM Supplier_Product_Performance_View;
 
BEGIN
    get_supplier_product_performance_view('lenovo@example.com'); 
END;
/
SELECT * FROM Supplier_Product_Performance_View;