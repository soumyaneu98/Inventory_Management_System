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
    name    VARCHAR2(20) NOT NULL,
    CONSTRAINT categories_pk PRIMARY KEY (ctgryid)
);

CREATE TABLE customers (
    custid      INTEGER,
    name        VARCHAR2(20) NOT NULL,
    email       VARCHAR2(40) NOT NULL,
    contactnum  NUMBER(10) NOT NULL,
    addr_street VARCHAR2(20) NOT NULL,
    addr_unit   VARCHAR2(4) NOT NULL,
    city        VARCHAR2(20) NOT NULL,
    country     VARCHAR2(20) NOT NULL,
    zip_code    VARCHAR2(6) NOT NULL,
    CONSTRAINT customers_pk PRIMARY KEY (custid),
    CONSTRAINT customers_email_contactnum_un UNIQUE (email, contactnum)
   );

CREATE TABLE discounts (
    discid INTEGER NOT NULL,
    value  INTEGER NOT NULL,
    name   VARCHAR2(20) NOT NULL,
    CONSTRAINT discounts_pk PRIMARY KEY (discid)
);

CREATE TABLE orders (
    orderid    INTEGER NOT NULL,
    orderdate  DATE DEFAULT SYSDATE NOT NULL,
    billamt    NUMBER(8, 2),
    shipstatus VARCHAR2(10),
    dlvrydate  DATE,
    custid     INTEGER NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY (orderid),
    CONSTRAINT orders_customers_fk FOREIGN KEY (custid) REFERENCES customers(custid)
);

CREATE TABLE suppliers (
    supid       INTEGER NOT NULL,
    name        VARCHAR2(20) NOT NULL,
    email       VARCHAR2(20) NOT NULL,
    contactnum  NUMBER(10) NOT NULL,
    addr_street VARCHAR2(20) NOT NULL,
    website     VARCHAR2(20),
    itin        VARCHAR2(20) NOT NULL,
    addr_unit   VARCHAR2(20) NOT NULL,
    city        VARCHAR2(20) NOT NULL,
    country     VARCHAR2(20) NOT NULL,
    zip_code    VARCHAR2(6) NOT NULL,
    CONSTRAINT suppliers_pk PRIMARY KEY (supid)
);

CREATE TABLE products (
    prodid      INTEGER NOT NULL,
    name        VARCHAR2(40) NOT NULL,
    description VARCHAR2(500) NOT NULL,
    price       NUMBER(7, 2) NOT NULL,
    qtyinstock  INTEGER NOT NULL,
    minqty      INTEGER,
    availstatus CHAR(1),
    warranty    INTEGER,
    supid       INTEGER NOT NULL,
    ctgryid     INTEGER NOT NULL,
    reorderqty  INTEGER,
    discid      INTEGER,
    CONSTRAINT products_pk PRIMARY KEY (prodid),
    CONSTRAINT products_categories_fk FOREIGN KEY (ctgryid) REFERENCES categories(ctgryid),
    CONSTRAINT products_discounts_fk FOREIGN KEY (discid) REFERENCES discounts(discid),
    CONSTRAINT products_suppliers_fk FOREIGN KEY (supid) REFERENCES suppliers(supid)
);

CREATE TABLE productorder (
    prodid       INTEGER NOT NULL,
    orderid      INTEGER NOT NULL,
    qty          INTEGER,
    final_price  NUMBER(7, 2),
    prodorder_id INTEGER NOT NULL,
    CONSTRAINT productorder_pk PRIMARY KEY (prodorder_id),
    CONSTRAINT productorder_orders_fk FOREIGN KEY (orderid) REFERENCES orders(orderid),
    CONSTRAINT productorder_products_fk FOREIGN KEY (prodid) REFERENCES products(prodid)
);


CREATE TABLE productsupply (
    productsupply_id INTEGER NOT NULL,
    orderdate        DATE DEFAULT SYSDATE NOT NULL,
    prodid           INTEGER NOT NULL,
    status           CHAR(1),
    refil_date       DATE,
    price            NUMBER(7, 2) NOT NULL,
    CONSTRAINT productsupply_pk PRIMARY KEY (productsupply_id),
    CONSTRAINT productsupply_products_fk FOREIGN KEY (prodid) REFERENCES products(prodid)
);

CREATE SEQUENCE categories_seq;
CREATE SEQUENCE customers_seq;
CREATE SEQUENCE discounts_seq;
CREATE SEQUENCE orders_seq;
CREATE SEQUENCE suppliers_seq;
CREATE SEQUENCE products_seq;
CREATE SEQUENCE productorder_seq;
CREATE SEQUENCE productsupply_seq;

select * from user_tables;

create table temp_table(i int);



