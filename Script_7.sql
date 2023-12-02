--Run this script as customer
ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
SET SERVEROUTPUT ON;
declare
    v_orderid_1 integer;
begin
    insert_order('john@example.com', TO_DATE('22-11-2023 08:30:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_1);
    InsertProductOrder(p_product_name => 'Ultra-Slim Laptop', p_orderid => v_orderid_1, p_qty => 5);
end;
/
 
declare
    v_orderid_2 integer;
begin
    insert_order('jane@example.com', TO_DATE('23-11-2023 10:45:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_2);
    InsertProductOrder(p_product_name => 'Gaming Laptop', p_orderid => v_orderid_2, p_qty => 3);
end;
/
 
declare
    v_orderid_3 integer;
begin
    insert_order('mike@example.com', TO_DATE('24-11-2023 14:20:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_3);
    InsertProductOrder(p_product_name => 'Convertible Laptop', p_orderid => v_orderid_3, p_qty => 2);
end;
/
 
declare
    v_orderid_4 integer;
begin
    insert_order('emily@example.com', TO_DATE('25-11-2023 09:15:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_4);
    InsertProductOrder(p_product_name => 'Business Ultrabook', p_orderid => v_orderid_4, p_qty => 1);
end;
/
 
declare
    v_orderid_5 integer;
begin
    insert_order('alex@example.com', TO_DATE('26-11-2023 11:30:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_5);
    InsertProductOrder(p_product_name => 'Budget Chromebook', p_orderid => v_orderid_5, p_qty => 4);
end;
/
 
declare
    v_orderid_6 integer;
begin
    insert_order('jessica@example.com', TO_DATE('27-11-2023 16:40:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_6);
    InsertProductOrder(p_product_name => 'High-Performance Workstation', p_orderid => v_orderid_6, p_qty => 3);
end;
/
 
declare
    v_orderid_7 integer;
begin
    insert_order('david@example.com', TO_DATE('28-11-2023 13:05:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_7);
    InsertProductOrder(p_product_name => 'Wireless Bluetooth Speaker', p_orderid => v_orderid_7, p_qty => 2);
end;
/
 
declare
    v_orderid_8 integer;
begin
    insert_order('sophia@example.com', TO_DATE('29-11-2023 08:50:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_8);
    InsertProductOrder(p_product_name => 'Surround Sound Speaker System', p_orderid => v_orderid_8, p_qty => 6);
end;
/
 
declare
    v_orderid_9 integer;
begin
    insert_order('daniel@example.com', TO_DATE('30-11-2023 12:25:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_9);
    InsertProductOrder(p_product_name => 'Smart Home Speaker', p_orderid => v_orderid_9, p_qty => 1);
end;
/
 
declare
    v_orderid_10 integer;
begin
    insert_order('olivia@example.com', TO_DATE('01-12-2023 14:55:00', 'DD-MM-YYYY HH24:MI:SS'), v_orderid_10);
    InsertProductOrder(p_product_name => 'Portable Outdoor Speaker', p_orderid => v_orderid_10, p_qty => 3);
end;
/