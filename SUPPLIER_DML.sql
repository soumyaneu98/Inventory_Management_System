ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
SET SERVEROUTPUT ON;
BEGIN
    ADD_SUPPLIERS('Apple Inc', 'apple@example.com', 1234567890, '1 Infinite Loop', 'www.apple.com', 123456789, '1101', 'Cupertino', 'USA', '95014');
    ADD_SUPPLIERS('Samsung Electronics', 'samsung@example.com', 9876543210, 'Samsung-ro 129', 'www.samsung.com', 987654321, '4102', 'Suwon', 'South Korea', '16678');
    ADD_SUPPLIERS('OnePlus Technology', 'oneplus@example.com', 5554443333, '20th Fl, Jingan', 'www.oneplus.com', 333333333, '9103', 'Delhi', 'India', '400040');
    ADD_SUPPLIERS('Lenovo Group Ltd', 'lenovo@example.com', 1112223333, 'Building 24', 'www.lenovo.com', 444444440, '7104', 'Mumbai', 'India', '401203');
    ADD_SUPPLIERS('Xiaomi Corporation', 'xiaomi@example.com', 6665554444, 'Building 3', 'www.xiaomi.com', 555555559, '9105', 'Beijing', 'China', '100102');
END;
/
COMMIT;