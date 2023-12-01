SET SERVEROUTPUT ON;
 
BEGIN 
FOR I IN (
WITH DESIRED_OBJECTS AS (
    SELECT 'PRODUCTSUPPLY'       OBJECT_NAME FROM DUAL
    UNION ALL 
    SELECT 'PRODUCTORDER'        FROM DUAL
    UNION ALL
    SELECT 'PRODUCTS'            FROM DUAL
    UNION ALL
    SELECT 'SUPPLIERS'           FROM DUAL
    UNION ALL 
    SELECT 'ORDERS'              FROM DUAL
    UNION ALL 
    SELECT 'DISCOUNTS'           FROM DUAL
    UNION ALL
    SELECT 'CUSTOMERS'           FROM DUAL
    UNION ALL
    SELECT 'CATEGORIES'          FROM DUAL
    UNION ALL
    SELECT 'CATEGORIES_SEQ'      FROM DUAL
    UNION ALL 
    SELECT 'CUSTOMERS_SEQ'       FROM DUAL
    UNION ALL
    SELECT 'DISCOUNTS_SEQ'       FROM DUAL
    UNION ALL
    SELECT 'ORDERS_SEQ'          FROM DUAL
    UNION ALL 
    SELECT 'SUPPLIERS_SEQ'       FROM DUAL
    UNION ALL 
    SELECT 'PRODUCTS_SEQ'        FROM DUAL
    UNION ALL
    SELECT 'PRODUCTORDER_SEQ'    FROM DUAL
    UNION ALL
    SELECT 'PRODUCTSUPPLY_SEQ'   FROM DUAL  
    )
    SELECT DT.OBJECT_NAME, UO.OBJECT_TYPE FROM DESIRED_OBJECTS DT JOIN USER_OBJECTS UO ON DT.OBJECT_NAME=UO.OBJECT_NAME 
)
LOOP
    DBMS_OUTPUT.PUT_LINE('DROP ' || I.OBJECT_TYPE || ' ' || I.OBJECT_NAME);
    EXECUTE IMMEDIATE 'DROP ' || I.OBJECT_TYPE || ' ' || I.OBJECT_NAME ;
END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SOMETHING WENT WRONG');
    END;
/
 
CREATE TABLE categories (
    ctgryid INTEGER NOT NULL,
    name    VARCHAR2(20) NOT NULL UNIQUE,
    CONSTRAINT categories_pk PRIMARY KEY (ctgryid)
);
 
CREATE TABLE customers (
    custid      INTEGER,
    name        VARCHAR2(20) NOT NULL,
    email       VARCHAR2(40) NOT NULL,
    contactnum  NUMBER(10)  NOT NULL,
    addr_street VARCHAR2(20) NOT NULL,
    addr_unit   VARCHAR2(4) NOT NULL,
    city        VARCHAR2(20) NOT NULL,
    country     VARCHAR2(20) DEFAULT 'USA' NOT NULL,
    zip_code    VARCHAR2(6) NOT NULL,
    CONSTRAINT customers_pk PRIMARY KEY (custid),
    CONSTRAINT customers_email_un UNIQUE (email),
    CONSTRAINT customers_contactnum_un UNIQUE (contactnum)
);

CREATE TABLE discounts (
    discid INTEGER NOT NULL,
    value  INTEGER NOT NULL,
    name   VARCHAR2(20) NOT NULL,
    CONSTRAINT discounts_pk PRIMARY KEY (discid)
    
);
 
CREATE TABLE orders (
    orderid    INTEGER NOT NULL,
    order_date  DATE DEFAULT SYSDATE NOT NULL,
    billamt    NUMBER(8, 2),
    shipstatus VARCHAR2(10),
    dlvry_date  DATE,
    custid     INTEGER NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (orderid),
    CONSTRAINT orders_customers_fk FOREIGN KEY (custid) REFERENCES customers(custid),
    CONSTRAINT DLVRY_ORDER_DT CHECK (dlvry_date >= order_date),
    CONSTRAINT SHIP_STATUS_VAL CHECK (shipstatus IN ('PROCESSING', 'IN-TRANSIT', 'DELIVERED'))
);
 
CREATE TABLE suppliers (
    supid       INTEGER NOT NULL,
    name        VARCHAR2(20) NOT NULL,
    email       VARCHAR2(40) NOT NULL,
    contactnum  NUMBER(10) NOT NULL,
    addr_street VARCHAR2(20) NOT NULL,
    website     VARCHAR2(20),
    itin        NUMBER(9) NOT NULL,
    addr_unit   VARCHAR2(4) NOT NULL,
    city        VARCHAR2(20) NOT NULL,
    country     VARCHAR2(20) DEFAULT 'USA' NOT NULL,
    zip_code    VARCHAR2(6) NOT NULL,
    CONSTRAINT suppliers_pk PRIMARY KEY (supid),
    CONSTRAINT suppliers_email_un UNIQUE (email),
    CONSTRAINT suppliers_contactnum_un UNIQUE (contactnum)
);
 
CREATE TABLE products (
    prodid      INTEGER NOT NULL,
    name        VARCHAR2(40) NOT NULL,
    description VARCHAR2(500) NOT NULL,
    price       NUMBER(7, 2) NOT NULL,
    qtyinstock  INTEGER NOT NULL,
    minqty      INTEGER,
    availstatus CHAR(1),
    warranty    INTEGER DEFAULT 3 NOT NULL,
    supid       INTEGER NOT NULL,
    ctgryid     INTEGER NOT NULL,
    reorderqty  INTEGER,
    discid      INTEGER,
    CONSTRAINT products_pk PRIMARY KEY (prodid),
    CONSTRAINT products_categories_fk FOREIGN KEY (ctgryid) REFERENCES categories(ctgryid),
    CONSTRAINT products_discounts_fk FOREIGN KEY (discid) REFERENCES discounts(discid),
    CONSTRAINT products_suppliers_fk FOREIGN KEY (supid) REFERENCES suppliers(supid),
    CONSTRAINT AVAIL_STATUS CHECK (AVAILSTATUS='Y' OR AVAILSTATUS='N' ),
    CONSTRAINT PRICE_GTE_1 CHECK ( PRICE >=1 )
);
 
CREATE TABLE productorder (
    prodid       INTEGER NOT NULL,
    orderid      INTEGER NOT NULL,
    qty          INTEGER NOT NULL,
    final_price  NUMBER(7, 2),
    prodorder_id INTEGER NOT NULL,
    CONSTRAINT productorder_pk PRIMARY KEY (prodorder_id),
    CONSTRAINT productorder_orders_fk FOREIGN KEY (orderid) REFERENCES orders(orderid),
    CONSTRAINT productorder_products_fk FOREIGN KEY (prodid) REFERENCES products(prodid),
    CONSTRAINT QTY_IN_STOCK_GT_0 CHECK ( qty > 0)
);
 
CREATE TABLE productsupply (
    productsupply_id INTEGER NOT NULL,
    order_date        DATE DEFAULT SYSDATE NOT NULL,
    prodid           INTEGER NOT NULL,
    status           CHAR(1) DEFAULT 'N',
    refil_date       DATE,
    price            NUMBER(7, 2) NOT NULL,
    CONSTRAINT productsupply_pk PRIMARY KEY (productsupply_id),
    CONSTRAINT productsupply_products_fk FOREIGN KEY (prodid) REFERENCES products(prodid),
    CONSTRAINT RFL_ORDER_DT CHECK (refil_date >= order_date OR refil_date IS NULL)
);

CREATE SEQUENCE categories_seq start with 1000;
CREATE SEQUENCE customers_seq start with 2000;
CREATE SEQUENCE discounts_seq start with 3000;
CREATE SEQUENCE orders_seq start with 4000;
CREATE SEQUENCE suppliers_seq start with 5000;
CREATE SEQUENCE products_seq start with 6000;
CREATE SEQUENCE productorder_seq start with 7000;
CREATE SEQUENCE productsupply_seq start with 8000;

---  Customers Product order View
CREATE OR REPLACE VIEW customer_order_view AS
SELECT
    o.orderid AS Orderld,
    o.order_date AS OrderDate,
    (po.qty * (p.price - (p.price * NVL(d.value, 0) / 100))) AS BillAmt,
    o.shipstatus AS ShipStatus,
    o.dlvry_date AS DlvryDate,
    po.qty AS Quantity,
    p.name AS ProductName,
    p.description AS ProductDescription,
    p.price AS ProductPrice,
    p.warranty AS ProductWarranty,
    s.name AS SupplierName,
    c.name AS CategoryName,
    NVL(d.name, 'No Discount') AS DiscountName
FROM
    orders o
JOIN
    productorder po ON o.orderid = po.orderid
JOIN
    products p ON po.prodid = p.prodid
JOIN
    suppliers s ON p.supid = s.supid
JOIN
    categories c ON p.ctgryid = c.ctgryid
LEFT JOIN
    discounts d ON p.discid = d.discid;
 
-- logistic Admin Order Status
CREATE OR REPLACE VIEW logistic_admin_order_status AS
SELECT
    o.orderid,
    o.order_date,  
    o.shipstatus,
    o.dlvry_date,
    c.name AS customer_name,
    c.email AS customer_email,
    c.contactnum AS customer_contact,
    c.city AS customer_city,
    c.country AS customer_country,
    c.name AS CustomerName,
    c.email AS CustomerEmail,
    c.contactnum AS CustomerContact,
    c.city AS CustomerCity,
    c.country AS CustomerCountry,
     p.name AS ProductName
FROM
    orders o
    JOIN 
    customers c ON o.custid = c.custid
    JOIN
    productorder po ON o.orderid = po.orderid
    JOIN
    products p ON po.prodid = p.prodid;

-- stock report
CREATE OR REPLACE VIEW stock_report AS
SELECT
    c.name AS CategoryName,
    p.name AS ProductName,
    p.qtyinstock,
    p.reorderqty,
    CASE WHEN p.qtyinstock <= p.reorderqty THEN 'Restock Needed' ELSE 'In Stock' END AS StockStatus
FROM
    products p
JOIN
    categories c ON p.ctgryid = c.ctgryid;
 
--Sales Report
CREATE  OR REPLACE VIEW sales_report AS
SELECT
    o.orderid,
    o.order_date,
    c.name AS CustomerName,
    p.name AS ProductName,
    po.qty,
    (po.qty * (p.price - (p.price * NVL(d.value, 0) / 100))) AS BillAmt
FROM
    orders o
JOIN
    customers c ON o.custid = c.custid
JOIN
    productorder po ON o.orderid = po.orderid
JOIN
    products p ON po.prodid = p.prodid
LEFT JOIN
    discounts d ON p.discid = d.discid;

-- Customer Product View
CREATE OR REPLACE VIEW customer_product_view AS
SELECT
    p.prodid,
    p.name AS ProductName,
    p.description AS ProductDescription,
    p.price,
    p.warranty,
    s.name AS SupplierName,
    c.name as CategoryName,
    d.name as DiscName
FROM
    products p
JOIN
    suppliers s ON p.supid = s.supid
JOIN
    categories c ON p.ctgryid = c.ctgryid
Left JOIN
    discounts d ON p.discid = d.discid;

--Function for checking if customer exists--
CREATE OR REPLACE FUNCTION GET_CUSTOMER_ID(PI_EMAIL VARCHAR)
RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
   SELECT CUSTID INTO V_ID FROM CUSTOMERS WHERE LOWER(EMAIL) = LOWER(PI_EMAIL);
   RETURN V_ID;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN V_ID;
   END;
/

--return product id if exist, else returns -1
CREATE OR REPLACE FUNCTION GET_PRODUCT_ID(PI_PNAME VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT PRODID INTO V_ID FROM PRODUCTS WHERE LOWER(NAME) = LOWER(PI_PNAME);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns supplier id if exist, else returns -1
CREATE OR REPLACE FUNCTION GET_SUPPLIER_ID_USING_EMAIL(PI_SUPL_EMAIL VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT SUPID INTO V_ID FROM SUPPLIERS WHERE LOWER(EMAIL) = LOWER(PI_SUPL_EMAIL);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

CREATE OR REPLACE FUNCTION GET_SUPPLIER_ID_USING_NAME(PI_SUPL_NAME VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT SUPID INTO V_ID FROM SUPPLIERS WHERE LOWER(NAME) = LOWER(PI_SUPL_NAME);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns customer id if exist, else returns -1
CREATE OR REPLACE FUNCTION GET_CUSTOMER_ID(PI_CUST_EMAIL VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT CUSTID INTO V_ID FROM CUSTOMERS WHERE LOWER(EMAIL) = LOWER(PI_CUST_EMAIL);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns discount id if a row exists with (discount) name, else returns -1
CREATE OR REPLACE FUNCTION GET_DISCOUNT_ID_USING_NAME(PI_DISC_NAME VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT DISCID INTO V_ID FROM DISCOUNTS WHERE LOWER(NAME) = LOWER(PI_DISC_NAME);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns discount id if a row exists with (discount) value, else returns -1
CREATE OR REPLACE FUNCTION GET_DISCOUNT_ID_USING_VALUE(PI_VALUE INTEGER) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT DISCID INTO V_ID FROM DISCOUNTS WHERE VALUE = PI_VALUE;
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns category id if category name is found, else returns -1
CREATE OR REPLACE FUNCTION GET_CATEGORY_ID(PI_CTGRY_NAME VARCHAR) RETURN INTEGER AS 
V_ID INTEGER:=-1;
BEGIN
SELECT CTGRYID INTO V_ID FROM CATEGORIES WHERE LOWER(NAME) = LOWER(PI_CTGRY_NAME);
RETURN V_ID;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    RETURN V_ID;
END;
/

-- returns 1 if availstatus is Y, 0 if availstatus is N, -1 if product not found
CREATE OR REPLACE FUNCTION GET_AVAIL_STATUS(PI_NAME VARCHAR) RETURN INTEGER AS
V_ERRM VARCHAR(100);
V_PID PRODUCTS.PRODID%TYPE;
V_NAME PRODUCTS.NAME%TYPE;
V_STATUS CHAR;
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
IF(V_NAME IS NULL OR LENGTH(V_NAME)=0) THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR LENGTH 0';
   RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSE
   V_PID :=  GET_PRODUCT_ID(PI_NAME);
END IF;
V_PID := GET_PRODUCT_ID(V_NAME);
IF(V_PID!=-1) THEN
    SELECT AVAILSTATUS INTO V_STATUS FROM PRODUCTS WHERE PRODID = V_PID;
    IF V_STATUS = 'Y' THEN
        RETURN 1;
    ELSIF V_STATUS = 'N' THEN 
        RETURN 0;
    END IF;
ELSE 
    RETURN -1;
END IF;
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- returns -1 if the product is not found, else returns the curernt stock qty of the product 
CREATE OR REPLACE FUNCTION GET_AVAIL_QTY(PI_NAME VARCHAR) RETURN INTEGER AS
V_NAME VARCHAR(500);
V_ERRM VARCHAR(100);
OP INTEGER:=-1;
V_PID PRODUCTS.PRODID%TYPE;
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := PI_NAME;
IF(LENGTH(V_NAME)=0 OR V_NAME IS NULL ) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
END IF;
V_PID := GET_PRODUCT_ID(V_NAME);
IF(V_PID!=-1) THEN 
    SELECT QTYINSTOCK INTO OP FROM PRODUCTS WHERE PRODID = V_PID;
    RETURN OP;
ELSE
    RETURN OP;
END IF;
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- insert product procedure
CREATE OR REPLACE PROCEDURE ADD_PRODUCT(PI_PNAME VARCHAR, PI_DESC VARCHAR, 
                                        PI_PRICE NUMBER, PI_QTY_IN_STOCK INTEGER, PI_WARRANTY INTEGER, 
                                        PI_SUPL_NAME VARCHAR, PI_CTGRY_NAME VARCHAR, PI_DISC_NAME VARCHAR DEFAULT NULL)
AS 
V_PID INTEGER;
V_SID INTEGER;
V_DISCID INTEGER;
V_CTGRYID INTEGER;
V_CALC_QTY INTEGER;
V_NAME VARCHAR(500);
V_DESC VARCHAR(500);
V_SUPL_NAME VARCHAR(500);
V_CTGRY_NAME VARCHAR(500);
V_SUPLNAME VARCHAR(20);
V_ERRM VARCHAR(100);
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_PNAME);
V_DESC := TRIM(PI_DESC);
V_SUPL_NAME := TRIM(PI_SUPL_NAME);
V_CTGRY_NAME := TRIM(PI_CTGRY_NAME);
V_PID := GET_PRODUCT_ID(V_NAME);
V_SID := GET_SUPPLIER_ID_USING_NAME(V_SUPL_NAME);
IF(V_DESC IS NULL) THEN
    V_DISCID := NULL;
ELSE
    V_DISCID := GET_DISCOUNT_ID_USING_NAME(PI_DISC_NAME);
END IF;
V_CTGRYID := GET_CATEGORY_ID(V_CTGRY_NAME);
IF(LENGTH(V_DESC)>500) THEN
   V_ERRM := 'DESCRIPTION CANNOT BE MORE THAN  500 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSIF(LENGTH(V_DESC)=0 OR V_DESC IS NULL ) THEN
    V_ERRM := 'DESCRIPTION CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF(LENGTH(V_NAME)=0 OR V_NAME IS NULL ) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSIF(PI_PRICE IS NULL) THEN
    V_ERRM := 'PRICE CANNOT BE  NULL';
    RAISE CUSTOM_EXCEPTION;
ELSIF(PI_PRICE<=1) THEN
    V_ERRM := 'PRICE CANNOT BE LESS THAN A DOLLOAR';
    RAISE CUSTOM_EXCEPTION;
ELSIF(PI_QTY_IN_STOCK IS NULL) THEN
    V_ERRM := 'QTY IN STOCK CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF(PI_QTY_IN_STOCK<50) THEN
    V_ERRM := 'QUANTITY IN STOCK SHOULD ATLEAST BE 50';
    RAISE CUSTOM_EXCEPTION;
ELSIF(PI_WARRANTY IS NULL) THEN
    V_ERRM := 'WARRANTY CANNOT BE NULL';
    RAISE CUSTOM_EXCEPTION;
ELSIF(PI_WARRANTY<1) THEN
    V_ERRM := 'WARRANTY SHOULD BE 1 MONTH OR MORE';
    RAISE CUSTOM_EXCEPTION;
ELSIF V_PID!=-1 THEN
    V_ERRM :='PRODUCT NAME ALREADY EXISTS';
    RAISE CUSTOM_EXCEPTION;
ELSIF V_SID=-1 THEN
    V_ERRM :=  'SUPPLIER NAME IS INVALID';
    RAISE CUSTOM_EXCEPTION;
ELSIF V_CTGRYID=-1 THEN
    V_ERRM := 'CATEGORY NAME IS INVALID';
    RAISE CUSTOM_EXCEPTION;
ELSIF V_DISCID=-1 THEN
    V_ERRM := 'DISCOUNT NAME IS INVALID';
    RAISE CUSTOM_EXCEPTION;
END IF;
V_CALC_QTY := CEIL(PI_QTY_IN_STOCK/2);
INSERT INTO PRODUCTS VALUES(products_seq.NEXTVAL, INITCAP(V_NAME), V_DESC, PI_PRICE, PI_QTY_IN_STOCK, V_CALC_QTY, 'Y', PI_WARRANTY, V_SID, V_CTGRYID, V_CALC_QTY , V_DISCID);
COMMIT;
DBMS_OUTPUT.PUT_LINE('PRODUCT ADDED SUCCESSFULLY !');
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('SOMETHIGN WENT WRONG ' || SQLERRM);
END;
/

CREATE OR REPLACE PROCEDURE UPDATE_PRODUCT_INFO(PI_NAME VARCHAR, PI_DESC VARCHAR, PI_PRICE NUMBER) AS
V_PID INTEGER;
V_NAME VARCHAR(100);
V_DESC VARCHAR(100);
V_ERRM VARCHAR(100);
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
V_DESC := TRIM(PI_DESC);
IF(LENGTH(V_DESC)>500) THEN
   V_ERRM := 'DESCRIPTION CANNOT BE MORE THAN  500 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSIF(LENGTH(V_NAME)=0 OR V_NAME IS NULL ) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSIF(PI_PRICE<=1) THEN
    V_ERRM := 'PRICE CANNOT BE LESS THAN A DOLLOAR';
    RAISE CUSTOM_EXCEPTION;
ELSIF V_PID=-1 THEN
    V_ERRM :='PRODUCT NAME NOT FOUND';
END IF;
UPDATE PRODUCTS SET DESCRIPTION = NVL(V_DESC, DESCRIPTION), PRICE = NVL(PI_PRICE, PRICE);
COMMIT;
DBMS_OUTPUT.PUT_LINE('PRODUCT UPDATED SUCCESSFULLY');
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- insert discount procedure
CREATE OR REPLACE PROCEDURE ADD_DISCOUNT(PI_NAME VARCHAR, PI_VALUE INTEGER) AS
V_DISCID_1 INTEGER;
V_DISCID_2 INTEGER;
V_ERRM VARCHAR(100);
CUSTOM_EXCEPTION EXCEPTION;
V_NAME VARCHAR(20);
BEGIN
V_NAME := TRIM(PI_NAME);
IF(LENGTH(V_NAME)=0 OR V_NAME IS NULL ) THEN
    V_ERRM := 'DISCOUNT NAME CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF(LENGTH(PI_VALUE)=0 OR PI_VALUE IS NULL ) THEN
    V_ERRM := 'DISCOUNT VALUE CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF (PI_VALUE<5) THEN
    V_ERRM := 'DISCOUNT VALUE SHOULD ATLEAST BE 5 PERCENT';
    RAISE CUSTOM_EXCEPTION;
END IF;
V_DISCID_1 := GET_DISCOUNT_ID_USING_NAME(V_NAME);
V_DISCID_2 := GET_DISCOUNT_ID_USING_VALUE(PI_VALUE);
IF(V_DISCID_1!=-1 OR V_DISCID_2!=-1 ) THEN
    V_ERRM := 'DISCOUNT ALEADY EXIST ';
    RAISE CUSTOM_EXCEPTION;
ELSE 
    INSERT INTO DISCOUNTS VALUES(DISCOUNTS_SEQ.NEXTVAL, PI_VALUE, UPPER(V_NAME));
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('DISCOUNT ADDED SUCCESSFULY');
END IF;
EXCEPTION 
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- insert category procedure
CREATE OR REPLACE PROCEDURE ADD_CATEGORY(PI_NAME VARCHAR) AS
V_CTGRYID INTEGER;
V_ERRM VARCHAR(100);
V_NAME VARCHAR(20);
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
IF(LENGTH(V_NAME)=0 OR V_NAME IS NULL ) THEN
    V_ERRM := 'CATEGORY NAME CANNOT BE NULL OR EMPTY';
    RAISE CUSTOM_EXCEPTION;
ELSIF(LENGTH(V_NAME)>20) THEN
    V_ERRM := 'CATEGORY NAME CANNOT BE MORE THAN 20 CHARACTERS';
    RAISE CUSTOM_EXCEPTION;
ELSE
    V_CTGRYID := GET_CATEGORY_ID(V_NAME);
    IF(V_CTGRYID!=-1) THEN 
        V_ERRM := 'CATEGORY NAME ALREADY EXIST';
        RAISE CUSTOM_EXCEPTION;
    ELSE 
        INSERT INTO CATEGORIES VALUES (DISCOUNTS_SEQ.NEXTVAL, INITCAP(V_NAME));
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('CATEGORY ADDED SUCCESSFULY');
    END IF;
END IF;
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- update availability status of a product ( toggle between Y and N )
CREATE OR REPLACE PROCEDURE UPDATE_AVAIL_STATUS(PI_NAME VARCHAR, PI_STATUS CHAR) AS
V_ERRM VARCHAR(100);
V_PID PRODUCTS.PRODID%TYPE;
V_NAME PRODUCTS.NAME%TYPE;
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
IF(V_NAME IS NULL OR LENGTH(V_NAME)=0) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR LENGTH 0';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSE
   V_PID :=  GET_PRODUCT_ID(PI_NAME);
END IF;
IF V_PID!=-1 THEN
    IF(UPPER(PI_STATUS)='Y' OR UPPER(PI_STATUS)='N') THEN
         IF(UPPER(PI_STATUS)='Y') THEN
             UPDATE PRODUCTS SET AVAILSTATUS='Y';
             COMMIT;
             DBMS_OUTPUT.PUT_LINE('PRODUCT IS NOW LIVE');         
         ELSE 
             UPDATE PRODUCTS SET AVAILSTATUS='N';
             COMMIT;
             DBMS_OUTPUT.PUT_LINE('PRODUCT IS NOT AVAILABLE AT THE MOMENT');
         END IF;
    ELSE 
         V_ERRM := 'INVALID FLAG FOR AVAIL STATUS' ;
         RAISE CUSTOM_EXCEPTION;
    END IF;
ELSE 
    V_ERRM := 'PRODUCT NOT FOUND' ;
    RAISE CUSTOM_EXCEPTION;
END IF;
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

-- update a product's discount from one value to another or null
CREATE OR REPLACE PROCEDURE UPDATE_PROD_DISC(PI_NAME VARCHAR, PI_DISC_NAME VARCHAR) AS
V_PID PRODUCTS.PRODID%TYPE;
V_NAME PRODUCTS.NAME%TYPE;
V_DISC_NAME VARCHAR(100);
V_ERRM VARCHAR(100);
V_DISCID DISCOUNTS.DISCID%TYPE;
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
V_DISC_NAME := TRIM(PI_DISC_NAME);
IF(V_NAME IS NULL OR LENGTH(V_NAME)=0) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR LENGTH 0';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
   V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSE
   V_PID :=  GET_PRODUCT_ID(PI_NAME);
   IF V_PID=-1 THEN
         V_ERRM := 'PRODUCT NOT FOUND' ;
        RAISE CUSTOM_EXCEPTION;  
   END IF;
END IF;
IF(V_DISC_NAME IS NULL OR LENGTH(V_DISC_NAME)=0) THEN
    V_ERRM := 'DISCOUNT DISSOCIATED SUCCESSFULLY';
    UPDATE PRODUCTS SET DISCID = NULL WHERE PRODID = V_PID;
    COMMIT;
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_DISC_NAME)>40 THEN
   V_ERRM := 'DISCOUNT NAME CANNOT BE MORE THAN 20 CHARACTERS';
   RAISE CUSTOM_EXCEPTION;
ELSE
   V_DISCID := GET_DISCOUNT_ID_USING_NAME(PI_DISC_NAME);
   IF V_DISCID=-1 THEN
        V_ERRM := 'DISCOUNT ID NOT FOUND';
        RAISE CUSTOM_EXCEPTION;
   END IF;
END IF;
UPDATE PRODUCTS SET DISCID = V_DISCID WHERE PRODID = V_PID;
COMMIT;
DBMS_OUTPUT.PUT_LINE('DISCOUNT REFERENCED SUCCESSFULLY');
EXCEPTION
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/

CREATE OR REPLACE PROCEDURE TOGGLE_SHIP_STATUS_UP(PI_OID INTEGER) AS
V_OID ORDERS.ORDERID%TYPE;
BEGIN
IF(PI_OID IS NULL OR PI_OID = '') THEN
    DBMS_OUTPUT.PUT_LINE('ORDER ID CANNOT BE NULL OR EMPTY');
END IF;
SELECT ORDERID INTO V_OID FROM ORDERS WHERE ORDERID = PI_OID;
UPDATE ORDERS SET SHIPSTATUS = (CASE WHEN SHIPSTATUS = 'PROCESSING' THEN 'IN-TRANSIT' 
                                     WHEN SHIPSTATUS = 'IN-TRANSIT' THEN 'DELIVERED' 
                                     WHEN SHIPSTATUS = 'DELIVERED' THEN 'DELIVERED' END) 
                                WHERE ORDERID = V_OID;
COMMIT;
DBMS_OUTPUT.PUT_LINE('ORDER UPDATED');
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ORDER ID NOT FOUND');
END;
/

CREATE OR REPLACE PROCEDURE TOGGLE_SHIP_STATUS_DOWN(PI_OID INTEGER) AS
V_OID ORDERS.ORDERID%TYPE;
BEGIN
IF(PI_OID IS NULL OR PI_OID = '') THEN
    DBMS_OUTPUT.PUT_LINE('ORDER ID CANNOT BE NULL OR EMPTY');
END IF;
SELECT ORDERID INTO V_OID FROM ORDERS WHERE ORDERID = PI_OID;
UPDATE ORDERS SET SHIPSTATUS = (CASE WHEN SHIPSTATUS = 'DELIVERED' THEN 'IN-TRANSIT' 
                                     WHEN SHIPSTATUS = 'IN-TRANSIT' THEN 'PROCESSING' 
                                     WHEN SHIPSTATUS = 'PROCESSING' THEN 'PROCESSING' END) 
                                WHERE ORDERID = V_OID;
COMMIT;
DBMS_OUTPUT.PUT_LINE('ORDER UPDATED');
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('ORDER ID NOT FOUND');
END;
/

-- Insert Order
CREATE OR REPLACE PROCEDURE insert_order (
    p_shipstatus IN VARCHAR2,
    p_custid     IN INTEGER,
    p_order_date IN DATE DEFAULT NULL
)
AS
    v_orderid INTEGER;
    v_default_order_date DATE;
BEGIN
    -- Generate next orderid from sequence
    SELECT orders_seq.NEXTVAL INTO v_orderid FROM dual;

    -- Set default order date to current date if not provided
    IF p_order_date IS NULL THEN
        v_default_order_date := SYSDATE;
    ELSE
        v_default_order_date := p_order_date;
    END IF;

    -- Set default values and insert into orders table
    INSERT INTO orders (
        orderid,
        order_date,
        billamt,
        shipstatus,
        dlvry_date,
        custid
    ) VALUES (
        v_orderid,
        v_default_order_date,
        0, -- Default billamt
        COALESCE(p_shipstatus, 'Processing'), -- Default shipstatus is 'Processing'
        v_default_order_date + 3, -- Default delivery date
        p_custid
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Order inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error inserting order: ' || SQLERRM);
END insert_order;
/

-- Update Order Total
CREATE OR REPLACE PROCEDURE update_order_totals AS
BEGIN
    FOR order_rec IN (SELECT DISTINCT orderid FROM orders) -- Iterate over distinct order IDs in the orders table
    LOOP
        -- Calculate total bill amount for the specific order
        UPDATE orders o
        SET billamt = (SELECT NVL(SUM(po.final_price * po.qty), 0)
                       FROM productorder po
                       WHERE po.orderid = order_rec.orderid)
        WHERE o.orderid = order_rec.orderid;
    END LOOP;

    COMMIT; -- Commit outside the loop
 
    DBMS_OUTPUT.PUT_LINE('Order totals updated successfully.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error updating order totals: ' || SQLERRM);
END update_order_totals;
/

--Insert Product Order
CREATE OR REPLACE PROCEDURE InsertProductOrder(
    p_product_name IN products.name%TYPE,
    p_orderid      IN productorder.orderid%TYPE,
    p_qty          IN productorder.qty%TYPE
) AS
    v_original_price products.price%TYPE;
    v_discount      discounts.value%TYPE;
    v_final_price   NUMBER(7, 2);
    v_prodorder_id  productorder.prodorder_id%TYPE;
    v_prodid        products.prodid%TYPE;
    v_available_qty products.qtyinstock%TYPE;
    v_existing_order_qty productorder.qty%TYPE;
    temp discounts.discid%TYPE;
BEGIN
    -- Get the product ID based on the product name
    SELECT prodid INTO v_prodid FROM products WHERE name = p_product_name;
 
    -- Get the original price of the product
    SELECT price INTO v_original_price FROM products WHERE prodid = v_prodid;
 
    -- Get the discount value for the product
    SELECT NVL((SELECT value FROM discounts WHERE discid = (SELECT discid FROM products WHERE prodid = v_prodid)), 0) INTO v_discount FROM dual;
   
   -- Calculate the final discounted price multiplied by quantity
    v_final_price := (v_original_price - (v_original_price * v_discount / 100));

    -- Check if the product already exists in the productorder table for the specified order
    SELECT qty INTO v_existing_order_qty
    FROM productorder
    WHERE prodid = v_prodid AND orderid = p_orderid;

    IF v_existing_order_qty IS NOT NULL THEN
        -- Product already exists in the order, raise an error
        RAISE_APPLICATION_ERROR(-20003, 'Product already exists in the order. Please update the product quantity.');
    END IF;
    
    -- Check if the available quantity is sufficient
    SELECT qtyinstock INTO v_available_qty
    FROM products
    WHERE prodid = v_prodid;

    IF v_available_qty < p_qty THEN
        -- Quantity not available
        RAISE_APPLICATION_ERROR(-20002, 'Insufficient quantity available for the product.');
    END IF;

    -- Use the productorder_seq sequence to generate the next value for prodorder_id
    SELECT productorder_seq.nextval INTO v_prodorder_id FROM dual;
 
    -- Insert the data into the productorder table
    INSERT INTO productorder (prodid, orderid, qty, final_price, prodorder_id)
    VALUES (v_prodid, p_orderid, p_qty, v_final_price, v_prodorder_id);

    -- Update the available quantity in the products table
    UPDATE products
    SET qtyinstock = qtyinstock - p_qty
    WHERE prodid = v_prodid;

    COMMIT;
    update_order_totals;
    DBMS_OUTPUT.PUT_LINE('Data inserted successfully into productorder table. Prodorder_id: ' || v_prodorder_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Product not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLCODE || ' - ' || SQLERRM);
        ROLLBACK;
END InsertProductOrder;
/

-- Update Product Quantity
CREATE OR REPLACE PROCEDURE update_product_quantity (
    p_orderid INTEGER,
    p_product_name VARCHAR2,
    p_new_qty INTEGER
)
AS
    v_prodid INTEGER;
    v_original_price NUMBER;
    v_discount NUMBER := 0; -- Default discount to 0 if not specified
    v_final_price NUMBER;
    v_product_count INTEGER;
    v_current_qty INTEGER;
BEGIN
    -- Get the product ID based on the product name
    SELECT prodid INTO v_prodid FROM products WHERE name = p_product_name;
 
    -- Get the original price of the product
    SELECT price INTO v_original_price FROM products WHERE prodid = v_prodid;

    -- Get the discount value for the product
    SELECT NVL((SELECT value FROM discounts WHERE discid = products.discid), 0) INTO v_discount FROM products WHERE prodid = v_prodid;

    -- Calculate the final discounted price
    v_final_price := v_original_price - (v_original_price * v_discount / 100);

    -- Check if the product is associated with the given order ID
    SELECT COUNT(*)
    INTO v_product_count
    FROM productorder
    WHERE orderid = p_orderid AND prodid = v_prodid;

    IF v_product_count = 0 THEN
        -- Product not associated with the order ID
        RAISE_APPLICATION_ERROR(-20001, 'Product not associated with the given order ID.');
    END IF;

    -- Get the current quantity in stock
    SELECT NVL(qtyinstock, 0) + NVL(qty, 0) INTO v_current_qty
    FROM products pr
    LEFT JOIN productorder po ON pr.prodid = po.prodid
    WHERE pr.prodid = v_prodid
    AND po.orderid = p_orderid;
 
    IF v_current_qty < p_new_qty THEN
        RAISE_APPLICATION_ERROR(-20002, 'Requested quantity exceeds the available quantity in stock.');
    END IF;
 
    -- Savepoint before making changes to the database
    SAVEPOINT before_update;

    -- Update the quantity in the products table
    UPDATE products
    SET qtyinstock = qtyinstock + ((NVL((SELECT qty FROM productorder WHERE orderid = p_orderid AND prodid = v_prodid), 0)) - p_new_qty)
    WHERE prodid = v_prodid;

    -- Update the quantity and final_price in the productorder table
    UPDATE productorder
    SET qty = p_new_qty,
        final_price = p_new_qty * v_final_price
    WHERE orderid = p_orderid
    AND prodid = v_prodid;

    -- Commit the transaction
    COMMIT;
 
    -- Update order totals
    update_order_totals;
 
    DBMS_OUTPUT.PUT_LINE('Product quantity and final price updated successfully.');
 
    -- Commit the transaction
    COMMIT;

    -- Update order totals
    update_order_totals;

    DBMS_OUTPUT.PUT_LINE('Product quantity and final price updated successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Rollback to the savepoint if a product is not found
        SAVEPOINT before_update;
        ROLLBACK TO before_update;
        DBMS_OUTPUT.PUT_LINE('Product not found associated with this order! Please add this product to the order.');
    WHEN OTHERS THEN
        -- Rollback in case of any other exception
        SAVEPOINT before_update;
        ROLLBACK TO before_update;
        DBMS_OUTPUT.PUT_LINE('Error updating product quantity and final price: ' || SQLERRM);
END update_product_quantity;
/

-- Procedure for Suppliers --
 
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ADD_SUPPLIERS( 
    si_name SUPPLIERS.NAME%TYPE,
    si_email SUPPLIERS.EMAIL%TYPE,
    si_num SUPPLIERS.CONTACTNUM%TYPE,
    si_street SUPPLIERS.ADDR_STREET%TYPE,
    si_website SUPPLIERS.WEBSITE%TYPE,
    si_itin SUPPLIERS.ITIN%TYPE,
    si_unit SUPPLIERS.ADDR_UNIT%TYPE,
    si_city SUPPLIERS.CITY%TYPE,
    si_country SUPPLIERS.COUNTRY%TYPE,
    si_zipcode SUPPLIERS.ZIP_CODE%TYPE
)
AS
    sup_name VARCHAR2(50);
    sup_country VARCHAR2(50);
    supid_exist INTEGER;
    null_parameter_name VARCHAR2(20);
    length_exceeding_column VARCHAR2(20);
    max_length NUMBER;
    E_SUP_EXIST EXCEPTION;
    E_NULLEMPTY_PARAM EXCEPTION;
    E_LENGTHY_PARAM EXCEPTION;
    E_INVALID_CONTACT EXCEPTION;
    E_INVALID_ITIN EXCEPTION;
    E_INVALID_UNIT EXCEPTION;
    E_INVALID_EMAIL EXCEPTION;
    E_LENGTHY_COUNTRY EXCEPTION;
    E_NAME_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_CITY_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_COUNTRY_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_INVALID_ZIPCODE EXCEPTION;
    
BEGIN
    max_length := 0;
    
    -- Storing supplier name in camel case --
    sup_name := INITCAP(TRIM(si_name));
    
    -- Setting default or input value for country --
    sup_country := COALESCE(TRIM(si_country), 'USA');
    
    -- Check if any parameter is null or empty except website --
    null_parameter_name :=
      CASE
        WHEN TRIM(si_name) IS NULL THEN 'Name'
        WHEN TRIM(si_email) IS NULL THEN 'Email ID'
        WHEN si_num IS NULL THEN 'Contact Number'
        WHEN TRIM(si_street) IS NULL THEN 'Street Address'
        WHEN si_itin IS NULL THEN 'ITIN'
        WHEN si_unit IS NULL THEN 'Unit Number'
        WHEN TRIM(si_city) IS NULL THEN 'City'
        WHEN TRIM(si_zipcode) IS NULL THEN 'Zip code'
        ELSE NULL
      END;
 
    -- If any parameter is null or empty, raise exception --
    IF null_parameter_name IS NOT NULL THEN
        RAISE E_NULLEMPTY_PARAM;
    END IF;
 
    -- Check if the length of the parameters exceeds the specified size in the DDL
    length_exceeding_column :=
        CASE
            WHEN LENGTH(si_name) > 20 THEN 'Name'
            WHEN LENGTH(si_email) > 40 THEN 'Email ID'
            WHEN LENGTH(si_street) > 20 THEN 'Street Address'
            WHEN LENGTH(si_website) > 20 THEN 'Website'
            WHEN LENGTH(si_unit) > 4 THEN 'Unit Number'
            WHEN LENGTH(si_city) > 20 THEN 'City'
            WHEN LENGTH(si_zipcode) > 6 THEN 'Zip code'
            ELSE NULL
        END;
 
    -- If any column length exceeds it's corresponding length, raise exception --
    IF length_exceeding_column IS NOT NULL THEN
        CASE length_exceeding_column
            WHEN 'Name' THEN max_length := 20;
            WHEN 'Email ID' THEN max_length := 40;
            WHEN 'Street Address' THEN max_length := 20;
            WHEN 'Website' THEN max_length := 20;
            WHEN 'Unit Number' THEN max_length := 4;
            WHEN 'City' THEN max_length := 20;
            ELSE max_length := 0;
        END CASE;
    END IF;
 
    -- If any column length exceeds, raise exception --
    IF max_length != 0 THEN
        RAISE E_LENGTHY_PARAM;
    END IF;
    
    -- Check if length of country is valid --
    IF LENGTH(si_country) > 20 THEN
        max_length := 20;
        RAISE E_LENGTHY_COUNTRY;
    END IF;
 
    -- Check if contact number is 10 digits --
    IF NOT REGEXP_LIKE(si_num, '^\d{10}$') THEN
        RAISE E_INVALID_CONTACT;
    END IF;
    
    -- Check for valid ITIN format --
    IF NOT REGEXP_LIKE(si_itin, '^[0-9]{9}$') THEN
        RAISE E_INVALID_ITIN;
    END IF;
    
    -- Check for valid Unit Number format --
    IF NOT REGEXP_LIKE(si_unit, '^[A-Za-z0-9]{1,4}$') THEN
        RAISE E_INVALID_UNIT;
    END IF;
    
    -- Check for valid Email ID --
    IF NOT REGEXP_LIKE(si_email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') THEN
        RAISE E_INVALID_EMAIL;
    END IF;
    
    -- Check if the name contains any numbers
    IF NOT REGEXP_LIKE(si_name, '^[a-zA-Z ]+$') THEN
        RAISE E_NAME_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the city contains any numbers
    IF NOT REGEXP_LIKE(si_city, '^[a-zA-Z ]+$') THEN
        RAISE E_CITY_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the country contains any numbers
    IF NOT REGEXP_LIKE(si_country, '^[a-zA-Z ]+$') THEN
        RAISE E_COUNTRY_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the zip code follows a specific pattern --
    IF NOT REGEXP_LIKE(si_zipcode, '^\d{5,6}$') THEN
        RAISE E_INVALID_ZIPCODE;
    END IF;
 
    supid_exist := GET_SUPPLIER_ID_USING_NAME(sup_name);
    
    IF supid_exist = -1
    THEN
        INSERT INTO SUPPLIERS 
        VALUES( suppliers_seq.NEXTVAL, TRIM(sup_name), TRIM(si_email), TRIM(si_num), TRIM(si_street), TRIM(si_website), TRIM(si_itin), TRIM(si_unit), TRIM(si_city), sup_country, TRIM(si_zipcode));
    ELSE
        RAISE E_SUP_EXIST;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Added Supplier successfully!');
 
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- Check which unique constraint is violated
        
        -- Unique constraint for email
        IF SQLERRM LIKE '%SUPPLIERS_EMAIL_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with email ' || si_email || ' already exists!');
            
        -- Unique constraint for contactnum
        ELSIF SQLERRM LIKE '%SUPPLIERS_CONTACTNUM_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with contact number ' || si_num || ' already exists!');
        
        -- Unique constraint for ITIN
        ELSIF SQLERRM LIKE '%SUPPLIERS_ITIN_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with itin ' || si_itin || ' already exists!');
            
        -- Unique constraint for supplier name
        ELSIF SQLERRM LIKE '%SUPPLIERS_NAME_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with name ' || sup_name || ' already exists!');
            
        ELSE
            RAISE DUP_VAL_ON_INDEX;
        END IF;
    WHEN E_NULLEMPTY_PARAM THEN
        DBMS_OUTPUT.PUT_LINE( null_parameter_name || ' cannot be null or empty!');
    WHEN E_LENGTHY_PARAM THEN
        DBMS_OUTPUT.PUT_LINE( length_exceeding_column || ' should not exceed ' || max_length || ' characters!');
    WHEN E_LENGTHY_COUNTRY THEN
        DBMS_OUTPUT.PUT_LINE('Country should not exceed ' || max_length || ' characters!');
    WHEN E_INVALID_CONTACT THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Contact Number!');
    WHEN E_INVALID_ITIN THEN
        DBMS_OUTPUT.PUT_LINE('Invalid ITIN!');
    WHEN E_INVALID_UNIT THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Unit Number!');
    WHEN E_INVALID_EMAIL THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Email ID!');
    WHEN E_NAME_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('Name should not contain numbers or special characters!');
    WHEN E_CITY_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('City should not contain numbers or special characters!');
    WHEN E_COUNTRY_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('Country should not contain numbers or special characters!');
    WHEN E_INVALID_ZIPCODE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Zip code!');
    WHEN E_SUP_EXIST THEN
        DBMS_OUTPUT.PUT_LINE('Supplier already exists!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong! ' || SQLERRM);
END ADD_SUPPLIERS;
/
 
-- Procedure for update suppliers --
 
CREATE OR REPLACE PROCEDURE UPDATE_SUPPLIER(
    si_email SUPPLIERS.EMAIL%TYPE,
    si_name SUPPLIERS.NAME%TYPE DEFAULT NULL,
    si_contactnum SUPPLIERS.CONTACTNUM%TYPE DEFAULT NULL,
    si_street SUPPLIERS.ADDR_STREET%TYPE DEFAULT NULL,
    si_website SUPPLIERS.WEBSITE%TYPE DEFAULT NULL,
    si_itin SUPPLIERS.ITIN%TYPE DEFAULT NULL,
    si_unit SUPPLIERS.ADDR_UNIT%TYPE DEFAULT NULL,
    si_city SUPPLIERS.CITY%TYPE DEFAULT NULL,
    si_country SUPPLIERS.COUNTRY%TYPE DEFAULT NULL,
    si_zipcode SUPPLIERS.ZIP_CODE%TYPE DEFAULT NULL
)
AS
    max_length NUMBER;
    supid_exist INTEGER;
    length_exceeding_column VARCHAR(20);
    E_SUP_NOTAVAIL EXCEPTION;
    E_NULLEMPTY_PARAM EXCEPTION;
    E_LENGTHY_PARAM EXCEPTION;
    E_INVALID_CONTACT EXCEPTION;
    E_INVALID_ITIN EXCEPTION;
    E_INVALID_UNIT EXCEPTION;
    E_NAME_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_CITY_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_COUNTRY_HAS_SPECIAL_CHARACTERS EXCEPTION;
    E_INVALID_ZIPCODE EXCEPTION;
    
BEGIN
    -- Get the supplier id based on unique email id --
    supid_exist := GET_SUPPLIER_ID_USING_EMAIL(TRIM(si_email));
        
    -- Check if the length of the parameters exceeds the specified size --
    length_exceeding_column :=
        CASE
            WHEN LENGTH(si_name) > 20 THEN 'Name'
            WHEN LENGTH(si_street) > 20 THEN 'Street Address'
            WHEN LENGTH(si_website) > 20 THEN 'Website'
            WHEN LENGTH(si_unit) > 4 THEN 'Unit Number'
            WHEN LENGTH(si_city) > 20 THEN 'City'
            WHEN LENGTH(si_country) > 20 THEN 'Country'
            WHEN LENGTH(si_zipcode) > 6 THEN 'Zip code'
            ELSE NULL
        END;
 
    -- If any column length exceeds it's corresponding length, raise exception --
    IF length_exceeding_column IS NOT NULL THEN
        CASE length_exceeding_column
            WHEN 'Name' THEN max_length := 20;
            WHEN 'Street Address' THEN max_length := 20;
            WHEN 'Website' THEN max_length := 20;
            WHEN 'Unit Number' THEN max_length := 4;
            WHEN 'City' THEN max_length := 20;
            WHEN 'Country' THEN max_length := 20;
            ELSE max_length := 0;
        END CASE;
    END IF;
 
    -- If any column length exceeds it's corresponding length, raise exception
    IF max_length != 0 THEN
        RAISE E_LENGTHY_PARAM;
    END IF;
 
    -- Check if contactnum is a valid 10-digit number
    IF si_contactnum IS NOT NULL AND NOT REGEXP_LIKE(si_contactnum, '^\d{10}$') THEN
        RAISE E_INVALID_CONTACT;
    END IF;
 
    -- Check if itin is a valid 9-digit number
    IF si_itin IS NOT NULL AND NOT REGEXP_LIKE(si_itin, '^[0-9]{9}$') THEN
        RAISE E_INVALID_ITIN;
    END IF;
 
    -- Check if unit is a valid 4-digit number
    IF si_unit IS NOT NULL AND NOT REGEXP_LIKE(si_unit, '^[A-Za-z0-9]{1,4}$') THEN
        RAISE E_INVALID_UNIT;
    END IF;
    
    -- Check if the name contains any numbers
    IF si_name IS NOT NULL AND NOT REGEXP_LIKE(si_name, '^[a-zA-Z ]+$') THEN
        RAISE E_NAME_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the city contains any numbers
    IF si_city IS NOT NULL AND NOT REGEXP_LIKE(si_city, '^[a-zA-Z ]+$') THEN
        RAISE E_CITY_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the country contains any numbers
    IF si_country IS NOT NULL AND NOT REGEXP_LIKE(si_country, '^[a-zA-Z ]+$') THEN
        RAISE E_COUNTRY_HAS_SPECIAL_CHARACTERS;
    END IF;
    
    -- Check if the zip code follows a specific pattern --
    IF si_zipcode IS NOT NULL AND NOT REGEXP_LIKE(si_zipcode, '^\d{5,6}$') THEN
        RAISE E_INVALID_ZIPCODE;
    END IF;
 
    UPDATE SUPPLIERS
    SET
        name = NVL(TRIM(si_name), name),
        contactnum = NVL(TRIM(si_contactnum), contactnum),
        addr_street = NVL(TRIM(si_street), addr_street),
        website = NVL(TRIM(si_website), website),
        itin = NVL(TRIM(si_itin), itin),
        addr_unit = NVL(TRIM(si_unit), addr_unit),
        city = NVL(TRIM(si_city), city),
        country = NVL(TRIM(si_country), country),
        zip_code = NVL(TRIM(si_zipcode), zip_code)
    WHERE supid = supid_exist;
    
    COMMIT;
 
    DBMS_OUTPUT.PUT_LINE('Supplier updated successfully!');
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        -- Check which unique constraint is violated
            
        -- Unique constraint for contactnum
        IF SQLERRM LIKE '%SUPPLIERS_CONTACTNUM_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with contact number ' || si_contactnum || ' already exists!');
        
        -- Unique constraint for ITIN
        ELSIF SQLERRM LIKE '%SUPPLIERS_ITIN_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with itin ' || si_itin || ' already exists!');
            
        -- Unique constraint for supplier name
        ELSIF SQLERRM LIKE '%SUPPLIERS_NAME_UN%' THEN
            DBMS_OUTPUT.PUT_LINE('Supplier with name ' || si_name || ' already exists!');
            
        ELSE
            RAISE DUP_VAL_ON_INDEX;
        END IF;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Supplier doesn''t exist');
    WHEN E_LENGTHY_PARAM THEN
        DBMS_OUTPUT.PUT_LINE( length_exceeding_column || ' should not exceed ' || MAX_LENGTH || ' characters!');
    WHEN E_INVALID_CONTACT THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Contact Number!');
    WHEN E_INVALID_ITIN THEN
        DBMS_OUTPUT.PUT_LINE('Invalid ITIN!');
    WHEN E_INVALID_UNIT THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Unit Number!');
    WHEN E_NAME_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('Name should not contain numbers or special characters!');
    WHEN E_CITY_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('City should not contain numbers or special characters!');
    WHEN E_COUNTRY_HAS_SPECIAL_CHARACTERS THEN
        DBMS_OUTPUT.PUT_LINE('Country should not contain numbers or special characters!');
    WHEN E_INVALID_ZIPCODE THEN
        DBMS_OUTPUT.PUT_LINE('Invalid Zip code!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END UPDATE_SUPPLIER;
/
 
--Procedure for adding customers--
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE ADD_CUSTOMERS
   (PI_NAME VARCHAR2,
    PI_EMAIL VARCHAR2,
    PI_CONTACTNUM NUMBER,
    PI_ADDR_STREET VARCHAR2,
    PI_ADDR_UNIT   VARCHAR2,
    PI_CITY        VARCHAR2,
    PI_COUNTRY    VARCHAR2 ,
    PI_ZIP_CODE   VARCHAR2)
AS
 V_CUST_EXISTS INTEGER;--To check whether cust id exists
 V_NULL_COLUMNNAME VARCHAR2(30);-- To check null column
 V_COLUMN_NAME VARCHAR2(30);--To check column for length
 V_COLUMN_LENGTH NUMBER; --To check allowed length for column
 V_COLUMN_TYPE VARCHAR2(30);--To check column for city or coutry type
 CUST_NAME VARCHAR2(50); --To get customer name
 E_CUST_EXISTS EXCEPTION;
 E_NULL_COLUMN EXCEPTION;
 E_LENGTH EXCEPTION;
 E_ZIPCODE_LENGTH EXCEPTION;
 E_TYPE_NAME_CITY_COUNTRY EXCEPTION;
 E_TYPE_ZIP_CODE EXCEPTION;
 E_TYPE_EMAIL EXCEPTION;
 V_COUNTRY VARCHAR(50);
 
BEGIN 
    -- Converting customer name to camel case --
    CUST_NAME := INITCAP(TRIM(PI_NAME));
    --Assigning country based on default
    V_COUNTRY:=COALESCE(TRIM(PI_COUNTRY), 'USA');
    
    --Determine first column that is null--
    V_NULL_COLUMNNAME:=
    CASE
          WHEN CUST_NAME IS NULL THEN 'Customer name'
          WHEN PI_EMAIL IS NULL THEN 'Customer email'
          WHEN PI_CONTACTNUM IS NULL THEN 'Customer contact'
          WHEN PI_ADDR_STREET IS NULL THEN 'Customer address street'
          WHEN PI_ADDR_UNIT IS NULL THEN 'Customer address unit'
          WHEN PI_CITY IS NULL THEN 'Customer city'
         -- WHEN PI_COUNTRY IS NULL THEN 'Customer country'
          WHEN PI_ZIP_CODE IS NULL THEN 'Customer zipcode'
          ELSE NULL
    END;
   
    IF V_NULL_COLUMNNAME IS NOT NULL THEN
    RAISE  E_NULL_COLUMN;
    END IF;
    
   -- Check the column and length  using CASE statement
    V_COLUMN_NAME :=
        CASE
            WHEN LENGTH(CUST_NAME) > 20 THEN 'NAME'
            WHEN LENGTH(PI_EMAIL) > 40 THEN 'EMAIL'
            WHEN LENGTH(PI_CONTACTNUM) <> 10 THEN 'CONTACTNUM'
            WHEN LENGTH(PI_ADDR_STREET) > 20 THEN 'ADDR_STREET'
            WHEN LENGTH(PI_ADDR_UNIT) > 4 THEN 'ADDR_UNIT'
            WHEN LENGTH(PI_CITY) > 20 THEN 'CITY'
            WHEN LENGTH(PI_COUNTRY) > 20 THEN 'COUNTRY'
            ELSE NULL
        END;

    V_COLUMN_LENGTH :=
        CASE V_COLUMN_NAME
            WHEN 'NAME' THEN 20
            WHEN 'EMAIL' THEN 40
            WHEN 'CONTACTNUM' THEN 10
            WHEN 'ADDR_STREET' THEN 20
            WHEN 'ADDR_UNIT' THEN 4
            WHEN 'CITY' THEN 20
            WHEN 'COUNTRY' THEN 20
            ELSE NULL
        END;

    IF V_COLUMN_NAME IS NOT NULL THEN
            RAISE E_LENGTH;
    END IF;
    
     IF LENGTH(PI_ZIP_CODE) NOT IN (5, 6) THEN
           RAISE E_ZIPCODE_LENGTH;
     END IF;   
        
  -- Check for type  in--
  
    --ZIP_CODE
    IF NOT REGEXP_LIKE(PI_ZIP_CODE, '^\d+$') THEN
        RAISE E_TYPE_ZIP_CODE;
    END IF;
    
    --NAME
    IF NOT REGEXP_LIKE(CUST_NAME, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'CUSTOMER NAME';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;
    
    --CITY
    IF NOT REGEXP_LIKE(PI_CITY, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'CITY';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;
    
    --COUNTRY
    IF NOT REGEXP_LIKE(PI_COUNTRY, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'COUNTRY';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;
    
     -- EMAIL
    IF NOT REGEXP_LIKE(PI_EMAIL, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RAISE E_TYPE_EMAIL;
    END IF;
    

 
    --Checking whether customer exists
    V_CUST_EXISTS:=GET_CUSTOMER_ID(PI_EMAIL);
    
    --Insertion
      IF V_CUST_EXISTS=-1 THEN
    
        INSERT INTO CUSTOMERS(custid,name ,email,contactnum ,addr_street,addr_unit ,city ,country,zip_code)
        VALUES(CUSTOMERS_SEQ.NEXTVAL,CUST_NAME,TRIM(PI_EMAIL), TRIM(PI_CONTACTNUM),TRIM(PI_ADDR_STREET),TRIM(PI_ADDR_UNIT),TRIM( PI_CITY) ,V_COUNTRY ,TRIM(PI_ZIP_CODE));
        COMMIT;
        
      ELSE
          RAISE E_CUST_EXISTS;
      END IF;
      
EXCEPTION
   WHEN E_NULL_COLUMN THEN
      DBMS_OUTPUT.PUT_LINE(V_NULL_COLUMNNAME||' cannot be null');
   WHEN E_LENGTH THEN
      IF(V_COLUMN_NAME='CONTACTNUM') THEN
         DBMS_OUTPUT.PUT_LINE('Contact number should be of exactly 10 digits ' );
      ELSE
         DBMS_OUTPUT.PUT_LINE('Length of '||V_COLUMN_NAME||' cannot exceed '||V_COLUMN_LENGTH);
      END IF;
   WHEN E_ZIPCODE_LENGTH THEN
         DBMS_OUTPUT.PUT_LINE('Zipcode should be of exactly 5 or 6 digits ' );
   WHEN E_TYPE_ZIP_CODE THEN
      DBMS_OUTPUT.PUT_LINE('Zipcode should only contain numbers');
   WHEN E_TYPE_NAME_CITY_COUNTRY THEN
      DBMS_OUTPUT.PUT_LINE(V_COLUMN_TYPE ||' should not contain any numbers or special characters');
   WHEN E_TYPE_EMAIL THEN
      DBMS_OUTPUT.PUT_LINE('Please enter valid email format');
   WHEN E_CUST_EXISTS THEN
      DBMS_OUTPUT.PUT_LINE('Customer already exists');
   WHEN DUP_VAL_ON_INDEX THEN
   
          IF(INSTR(SQLERRM,'CUSTOMERS_EMAIL_UN')>0) THEN
                    DBMS_OUTPUT.PUT_LINE('Customer email already exists');
          ELSIF (INSTR(SQLERRM,'CUSTOMERS_CONTACTNUM_UN')>0) THEN
                    DBMS_OUTPUT.PUT_LINE('Customer contact number already exists');
          END IF;
  WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error '||SQLERRM);

END ADD_CUSTOMERS;
/  
--Procedure for updating customer--
CREATE OR REPLACE PROCEDURE UPDATE_CUSTOMER(
    PI_Email IN VARCHAR2,
    PI_Name IN VARCHAR2 DEFAULT NULL,
    PI_ContactNum IN NUMBER DEFAULT NULL,
    PI_Addr_Street IN VARCHAR2 DEFAULT NULL,
    PI_Addr_Unit IN VARCHAR2 DEFAULT NULL,
    PI_City IN VARCHAR2 DEFAULT NULL,
    PI_Country IN VARCHAR2 DEFAULT NULL,
    PI_Zip_Code IN VARCHAR2 DEFAULT NULL
)
AS
 V_CUST_EXISTS NUMBER;--To check whether cust id exists
 V_COLUMN_NAME VARCHAR2(30);--To check column for length
 V_COLUMN_LENGTH NUMBER; --To check allowed length for column
 V_COLUMN_TYPE VARCHAR2(30);--To check column for city or coutry type
 CUST_NAME VARCHAR2(50); --To get customer name
 E_CUST_EXISTS EXCEPTION;
 E_LENGTH EXCEPTION;
 E_ZIPCODE_LENGTH EXCEPTION;
 E_TYPE_NAME_CITY_COUNTRY EXCEPTION;
 E_TYPE_ZIP_CODE EXCEPTION;
 E_TYPE_EMAIL EXCEPTION;
BEGIN
   
     V_CUST_EXISTS:=GET_CUSTOMER_ID(TRIM(PI_Email));

    -- Check the column and length using CASE statement
    V_COLUMN_NAME :=
        CASE
            WHEN PI_Name IS NOT NULL AND LENGTH(PI_Name) > 20 THEN 'NAME'
            WHEN PI_Email IS NOT NULL AND LENGTH(PI_Email) > 40 THEN 'EMAIL'
            WHEN PI_ContactNum IS NOT NULL AND LENGTH(PI_ContactNum) <> 10 THEN 'CONTACTNUM'
            WHEN PI_Addr_Street IS NOT NULL AND LENGTH(PI_Addr_Street) > 20 THEN 'ADDR_STREET'
            WHEN PI_Addr_Unit IS NOT NULL AND LENGTH(PI_Addr_Unit) > 4 THEN 'ADDR_UNIT'
            WHEN PI_City IS NOT NULL AND LENGTH(PI_City) > 20 THEN 'CITY'
            WHEN PI_Country IS NOT NULL AND LENGTH(PI_Country) > 20 THEN 'COUNTRY'
            ELSE NULL
        END;

    V_COLUMN_LENGTH :=
        CASE V_COLUMN_NAME
            WHEN 'NAME' THEN 20
            WHEN 'EMAIL' THEN 40
            WHEN 'CONTACTNUM' THEN 10
            WHEN 'ADDR_STREET' THEN 20
            WHEN 'ADDR_UNIT' THEN 4
            WHEN 'CITY' THEN 20
            WHEN 'COUNTRY' THEN 20
            WHEN 'ZIP_CODE' THEN 6
            ELSE NULL
        END;

    IF V_COLUMN_NAME IS NOT NULL THEN
        RAISE E_LENGTH;
    END IF;
    --Length of zipcode
    IF LENGTH(PI_ZIP_CODE) NOT IN (5, 6) THEN
           RAISE E_ZIPCODE_LENGTH;
     END IF;  
    
    -- Check for type
    -- ZIP_CODE
    IF PI_Zip_Code IS NOT NULL AND NOT REGEXP_LIKE(PI_Zip_Code, '^\d+$') THEN
        RAISE E_TYPE_ZIP_CODE;
    END IF;

    -- NAME
    IF PI_Name IS NOT NULL AND NOT REGEXP_LIKE(PI_Name, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'CUSTOMER NAME';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;

    -- CITY
    IF PI_City IS NOT NULL AND NOT REGEXP_LIKE(PI_CITY, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'CITY';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;

    -- COUNTRY
    IF PI_Country IS NOT NULL AND NOT REGEXP_LIKE(PI_COUNTRY, '^[a-zA-Z ]+$') THEN
        V_COLUMN_TYPE := 'COUNTRY';
        RAISE E_TYPE_NAME_CITY_COUNTRY;
    END IF;
    
     -- EMAIL
    IF NOT REGEXP_LIKE(PI_EMAIL, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RAISE E_TYPE_EMAIL;
    END IF;
    
   
    UPDATE CUSTOMERS
    SET 
        name = COALESCE(TRIM(PI_Name), name),
        contactnum = COALESCE(PI_ContactNum, contactnum),
        addr_street = COALESCE(TRIM(PI_Addr_Street), addr_street),
        addr_unit = COALESCE(TRIM(PI_Addr_Unit), addr_unit),
        city = COALESCE(TRIM(PI_City), city),
        country = COALESCE(TRIM(PI_Country), country),
        zip_code = COALESCE(TRIM(PI_Zip_Code), zip_code)
    WHERE V_CUST_EXISTS = custid;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Customer updated successfully!');
    
EXCEPTION
   WHEN E_LENGTH THEN
      IF(V_COLUMN_NAME='CONTACTNUM') THEN
         DBMS_OUTPUT.PUT_LINE('Contact number should be of exactly 10 digits ' );
      ELSE
         DBMS_OUTPUT.PUT_LINE('Length of '||V_COLUMN_NAME||' cannot exceed '||V_COLUMN_LENGTH);
      END IF;
   WHEN E_ZIPCODE_LENGTH THEN
         DBMS_OUTPUT.PUT_LINE('Zipcode should be of exactly 5 or 6 digits ' );
   WHEN E_TYPE_ZIP_CODE THEN
      DBMS_OUTPUT.PUT_LINE('Zipcode should only contain numbers');
   WHEN E_TYPE_NAME_CITY_COUNTRY THEN
      DBMS_OUTPUT.PUT_LINE(V_COLUMN_TYPE ||' should not contain any numbers or special characters');
   WHEN E_TYPE_EMAIL THEN
      DBMS_OUTPUT.PUT_LINE('Please enter valid email format');
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No customer found with Email ' || PI_Email);
   WHEN DUP_VAL_ON_INDEX THEN
         IF (INSTR(SQLERRM,'CUSTOMERS_CONTACTNUM_UN')>0) THEN
                    DBMS_OUTPUT.PUT_LINE('Customer contact number already exists');
          END IF;
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error '||SQLERRM);
 
END UPDATE_CUSTOMER;
/

-- proc to update qty of the current inv (current inv = current iv + reorder qty)
CREATE OR REPLACE PROCEDURE UPDATE_INV_QTY(PI_PID INTEGER) AS
BEGIN
UPDATE PRODUCTS SET QTYINSTOCK = QTYINSTOCK + REORDERQTY WHERE PRODID = PI_PID;
IF SQL%ROWCOUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('RESTOCKED SUCCESSFULLY');
    COMMIT;
ELSE
    DBMS_OUTPUT.PUT_LINE('PRODUCT NOT FOUND');
END IF;
EXCEPTION
WHEN OTHERS THEN
   DBMS_OUTPUT.PUT_LINE('SOMETHIGN WENT WRONG, CONTACT ADMIN WITH SQL CODE ' || SQLCODE); 
END;
/

-- places an order only if there are no existing orders with 'N' flag into the product supply table 
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_SUPPLY(
    psi_prodid IN INTEGER
)
AS
    v_price INT;
    V_DATA_COUNT INTEGER;
    E_INVALID_STATUS EXCEPTION;
BEGIN
    SELECT price INTO v_price
    FROM products
    WHERE prodid = psi_prodid;
    -- Insert data into ProductSupply table
    SELECT COUNT(ProductSupply_Id) INTO V_DATA_COUNT  FROM PRODUCTSUPPLY WHERE PRODID = psi_prodid AND STATUS = 'N';
    IF(V_DATA_COUNT=0) THEN
        INSERT INTO ProductSupply (ProductSupply_Id, ProdId,  Price)
        VALUES (productsupply_seq.NEXTVAL, psi_prodid, 0.6*v_price);
        DBMS_OUTPUT.PUT_LINE('Product Supply added successfully!');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('PREVIOUS ORDER EXIST WITH SAME PRODUCT, CONTACT SUPPLIER TO FULFILL THE REQUEST ');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No product found with the given prodid !');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Something went wrong! ' || SQLERRM);
END ADD_PRODUCT_SUPPLY;
/
 
-- for each product, it says how much does the supplier needs to refill back to the inventory
create or replace view inv_order_requests as 
(
select p.prodid, p.supid, p.name, reorderqty*info.cnt pending_order_req  from products  p join 
(select prodid, count(productsupply_id) cnt from productsupply  where status = 'N' group by prodid) info
on p.prodid = info.prodid
);

CREATE OR REPLACE PROCEDURE GET_SUPPLIER_ORDER_REQ_USING_PRODNAME(PI_SUPNAME VARCHAR, PI_NAME VARCHAR) AS
V_PID PRODUCTS.PRODID%TYPE;
V_SID SUPPLIERS.SUPID%TYPE;
V_SUPNAME VARCHAR(100);
V_NAME PRODUCTS.NAME%TYPE;
V_ACCESS VARCHAR(20) := 'ACCESS DENIED';
V_ERRM VARCHAR(100);
CUSTOM_EXCEPTION EXCEPTION;
BEGIN
V_NAME := TRIM(PI_NAME);
V_SUPNAME := TRIM(PI_SUPNAME);
IF(V_NAME IS NULL OR LENGTH(V_NAME)=0) THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE NULL OR LENGTH 0';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_NAME)>40 THEN
    V_ERRM := 'PRODUCT NAME CANNOT BE MORE THAN 40 CHARACTERS';
    RAISE CUSTOM_EXCEPTION;
ELSIF(V_SUPNAME IS NULL OR LENGTH(V_SUPNAME)=0) THEN
    V_ERRM := 'SUPPPLIER NAME CANNOT BE NULL OR LENGTH 0';
    RAISE CUSTOM_EXCEPTION;
ELSIF LENGTH(V_SUPNAME)> 20 THEN
    V_ERRM := 'SUPPLIER NAME CANNOT BE MORE THAN 20 CHARACTERS';
    RAISE CUSTOM_EXCEPTION;
END IF;
V_PID :=  GET_PRODUCT_ID(V_NAME);
V_SID := GET_SUPPLIER_ID_USING_NAME(V_SUPNAME);
IF V_PID=-1 THEN
   V_ERRM := 'PRODUCT NOT FOUND' ;
   RAISE CUSTOM_EXCEPTION;  
END IF;
IF V_SID=-1 THEN
   V_ERRM := 'SUPPLIER NOT FOUND' ;
   RAISE CUSTOM_EXCEPTION;  
END IF;
SELECT 'GRANTED' INTO V_ACCESS FROM PRODUCTS WHERE SUPID = V_SID AND PRODID = V_PID; 
for i in(
select * from inv_order_requests WHERE PRODID = V_PID  AND SUPID = V_SID
)
loop
DBMS_OUTPUT.PUT_LINE('PRODUCT ID : ' || i.prodid || ' , PRODUCT NAME : '|| i.name || ' , PENDING ORDER QTY : ' || i.pending_order_req);
end loop;
EXCEPTION
WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(V_ACCESS);
WHEN CUSTOM_EXCEPTION THEN
    DBMS_OUTPUT.PUT_LINE(V_ERRM);
END;
/


