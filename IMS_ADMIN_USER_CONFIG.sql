SET SERVEROUTPUT ON;

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE CUSTOMER_ROLE';
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = -1924 THEN
     DBMS_OUTPUT.PUT_LINE('CREATING ROLE CUSTOMER_ROLE');
    END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE SUPPLIER_ROLE';
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = -1924 THEN
     DBMS_OUTPUT.PUT_LINE('CREATING ROLE SUPPLIER_ROLE');
    END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE LOGISTICS_ROLE';
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = -1924 THEN
     DBMS_OUTPUT.PUT_LINE('CREATING ROLE LOGISCTIC_ROLE');
    END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP ROLE MANAGER_ROLE';
EXCEPTION
WHEN OTHERS THEN
    IF SQLCODE = -1924 THEN
     DBMS_OUTPUT.PUT_LINE('CREATING ROLE MANAGER_ROLE');
    END IF;
END;
/

-- Creating and Granting privileges to Customer Role --
CREATE ROLE CUSTOMER_ROLE;
GRANT SELECT, INSERT, UPDATE ON ORDERS TO CUSTOMER_ROLE;
GRANT SELECT, INSERT, UPDATE ON PRODUCTORDER TO CUSTOMER_ROLE;
GRANT SELECT, INSERT, UPDATE ON CUSTOMERS TO CUSTOMER_ROLE;
GRANT SELECT ON orders_seq TO CUSTOMER_ROLE;
GRANT SELECT ON productorder_seq TO CUSTOMER_ROLE;
GRANT SELECT ON customers_seq TO CUSTOMER_ROLE;

-- Creating and Granting privileges to Supplier Role --
CREATE ROLE SUPPLIER_ROLE;
GRANT SELECT, UPDATE ON PRODUCTS TO SUPPLIER_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON SUPPLIERS TO SUPPLIER_ROLE;
GRANT SELECT, UPDATE ON PRODUCTSUPPLY TO SUPPLIER_ROLE;
GRANT SELECT ON suppliers_seq TO SUPPLIER_ROLE;

-- Creating and Granting privileges to Logistics Role --
CREATE ROLE LOGISTICS_ROLE;
GRANT SELECT ON PRODUCTS TO LOGISTICS_ROLE;
GRANT SELECT ON CATEGORIES TO LOGISTICS_ROLE;
GRANT SELECT ON SUPPLIERS TO LOGISTICS_ROLE;
GRANT SELECT, UPDATE ON ORDERS TO LOGISTICS_ROLE;
GRANT SELECT ON CUSTOMERS TO LOGISTICS_ROLE;

-- Creating and Granting privileges to Manager Role --
CREATE ROLE MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON PRODUCTS TO MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON CATEGORIES TO MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON DISCOUNTS TO MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON SUPPLIERS TO MANAGER_ROLE;
GRANT SELECT, UPDATE ON ORDERS TO MANAGER_ROLE;
GRANT SELECT ON PRODUCTORDER TO MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON PRODUCTSUPPLY TO MANAGER_ROLE;
GRANT SELECT, INSERT, DELETE, UPDATE ON CUSTOMERS TO MANAGER_ROLE;
GRANT SELECT ON products_seq TO MANAGER_ROLE;
GRANT SELECT ON categories_seq TO MANAGER_ROLE;
GRANT SELECT ON discounts_seq TO MANAGER_ROLE;
GRANT SELECT ON suppliers_seq TO MANAGER_ROLE;
GRANT SELECT ON productsupply_seq TO MANAGER_ROLE;
GRANT SELECT ON customers_seq TO MANAGER_ROLE;

DECLARE
    v_sid NUMBER;      
    v_serial NUMBER;   
    v_user VARCHAR2(100);
BEGIN
    
    FOR I IN (
    SELECT SID, SERIAL#
    FROM V$SESSION
    WHERE USERNAME IN ('SUPPLIER', 'CUSTOMER','LOGISTIC_ADMIN','IMS_MANAGER')
    )
    LOOP
     DBMS_OUTPUT.PUT_LINE('ALTER SYSTEM KILL SESSION ' || '''' || I.SID  || ',' || I.SERIAL# || '''');
     EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ' || '''' || I.SID  || ',' || I.SERIAL# || '''';
     DBMS_LOCK.SLEEP(1);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('CONTACT ADMIN WITH ERROR CODE : ' || SQLCODE);
END;
/
                          
-- Delete the users if already present --
DECLARE
    V_USER VARCHAR(100);
    V_DROP_SQL VARCHAR(500);
BEGIN
    FOR I IN (
    WITH DESIRED_USERS AS (
    SELECT 'CUSTOMER' USERNAME FROM DUAL
    UNION ALL
    SELECT 'SUPPLIER' FROM DUAL
    UNION ALL
    SELECT 'LOGISTIC_ADMIN' FROM DUAL
    UNION ALL
    SELECT 'IMS_MANAGER' FROM DUAL
    )
SELECT DU.USERNAME FROM DESIRED_USERS DU JOIN ALL_USERS AU ON DU.USERNAME = AU.USERNAME
)
LOOP
    EXECUTE IMMEDIATE 'DROP USER ' || I.USERNAME || ' CASCADE';
END LOOP;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('SOMETHING WENT WRONG. CONTACT ADMIN');
END;
/

-- Create and Grant privileges to Customer, Supplier, Logistics_Admin and IMS_Manager users --
CREATE USER CUSTOMER IDENTIFIED BY "TeamRelationalNinjas2023#";
GRANT CONNECT, RESOURCE, CUSTOMER_ROLE TO CUSTOMER;

CREATE USER SUPPLIER IDENTIFIED BY "TeamRelationalNinjas2023#";
GRANT CONNECT, RESOURCE, SUPPLIER_ROLE TO SUPPLIER;

CREATE USER LOGISTIC_ADMIN IDENTIFIED BY "TeamRelationalNinjas2023#";
GRANT CONNECT, RESOURCE, LOGISTICS_ROLE TO LOGISTIC_ADMIN;

CREATE USER IMS_MANAGER IDENTIFIED BY "TeamRelationalNinjas2023#";
GRANT CONNECT, RESOURCE, MANAGER_ROLE TO IMS_MANAGER;
