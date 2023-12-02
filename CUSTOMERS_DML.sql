ALTER SESSION SET CURRENT_SCHEMA = IMS_ADMIN;
SET SERVEROUTPUT ON;
-- Execute the ADD_CUSTOMERS procedure for each customer data
BEGIN
    ADD_CUSTOMERS('John Doe', 'john@example.com', 1234567890, '123 Oak St', '101', 'New York', 'United States', '10001');
    ADD_CUSTOMERS('Jane Smith', 'jane@example.com', 9876543210, '456 Pine St', '102', 'Los Angeles', 'United States', '90001');
    ADD_CUSTOMERS('Mike Johnson', 'mike@example.com', 5551112222, '789 Maple St', '103', 'Chicago', 'United States', '60601');
    ADD_CUSTOMERS('Emily White', 'emily@example.com', 9998887777, '321 Cedar St', '104', 'Houston', 'United States', '77001');
    ADD_CUSTOMERS('Alex Brown', 'alex@example.com', 1112223333, '654 Elm St', '202', 'Phoenix', 'United States', '85001');
    ADD_CUSTOMERS('Jessica Lee', 'jessica@example.com', 7778889999, '876 Birch St', '130', 'Philadelphia', 'United States', '19101');
    ADD_CUSTOMERS('David Miller', 'david@example.com', 3334445555, '987 Maple St', '203', 'San Antonio', 'United States', '78201');
    ADD_CUSTOMERS('Sophia Taylor', 'sophia@example.com', 6667778888, '123 Cedar St', '303', 'San Diego', 'United States', '92101');
    ADD_CUSTOMERS('Daniel Wilson', 'daniel@example.com', 4445556666, '234 Pine St', '640', 'Dallas', 'United States', '75201');
    ADD_CUSTOMERS('Olivia Smith', 'olivia@example.com', 8889990000, '567 Oak St', '220', 'Austin', 'United States', '73301');
END;
/

