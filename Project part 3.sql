-- CREATE DATABASE testdb;
USE testdb;

-- Disable foreign key checks for the initial setup
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF exists Contractor;
DROP TABLE IF exists Administrator;
DROP TABLE IF exists Client;
DROP TABLE IF exists QuoteRequest;
DROP TABLE IF exists QuoteResponse;
DROP TABLE IF exists ClientRespondToQuoteResponse;
DROP TABLE IF exists ContractorRespondToClientResponse;
DROP TABLE IF exists OrderOfWork;
DROP TABLE IF exists Bills;
DROP TABLE IF exists ResponseToBill;


CREATE TABLE Contractor
(
    ContractorID INT PRIMARY KEY DEFAULT 1,       
    Username VARCHAR(50),
    Password VARCHAR(50),
    Email VARCHAR(50)
);

CREATE TABLE Administrator
(
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(50) ,
    Username VARCHAR(50),
    Password VARCHAR(50)
);

CREATE TABLE Client (
    ClientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Password VARCHAR(50),
    Address VARCHAR(200),
    CreditCardInfo VARCHAR(10),
    PhoneNumber VARCHAR(10),
    Email VARCHAR(50) UNIQUE,
    UNIQUE (ClientID)
);

CREATE TABLE QuoteRequest
(
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    ClientID INT,   
    RequestDate DATE,
	NumberOfTrees INT,
    Note VARCHAR(200),
    Size VARCHAR(10), 
    Height DECIMAL(3, 1), 
    Location VARCHAR(100),
    ProximityToHouse FLOAT (20),
    UNIQUE (RequestID),
    FOREIGN KEY (ClientID) REFERENCES Client (ClientID)    
);

CREATE TABLE QuoteResponse
(
    ResponseID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    ClientID INT,
    ResponseDate DATE,
    Price DOUBLE,
    WorkPeriodFrom DATE,
    WorkPeriodTo DATE,     
    Note VARCHAR(200),
    UNIQUE (ResponseID),
    FOREIGN KEY (RequestID) REFERENCES QuoteRequest (RequestID),
	FOREIGN KEY (ClientID) REFERENCES QuoteRequest (ClientID)
);

CREATE TABLE ClientRespondToQuoteResponse (
    ClientResponseID INT AUTO_INCREMENT PRIMARY KEY,
    ContractorID INT,
    ResponseID INT,
    ResponseDate DATE,
    Status ENUM('Accepted', 'Rejected', 'Pending', 'RequestAgain'),
    Note VARCHAR(255),
    UNIQUE (ClientResponseID),
    FOREIGN KEY (ContractorID) REFERENCES Contractor(ContractorID),
    FOREIGN KEY (ResponseID) REFERENCES QuoteResponse(ResponseID)
);

CREATE TABLE ContractorRespondToClientResponse (
    ContractorResponseID INT AUTO_INCREMENT PRIMARY KEY,
    ContractorID INT,
    ClientResponseID INT,
    Status ENUM('Accepted', 'Rejected', 'Pending', 'RequestAgain'),
    ResponseDate DATE,
    Note VARCHAR(255),
    ModifiedPrice DOUBLE,
    ModifiedWorkPeriodFrom DATE,
    ModifiedWorkPeriodTo DATE,  
    FOREIGN KEY (ContractorID) REFERENCES Contractor(ContractorID),
    FOREIGN KEY (ClientResponseID) REFERENCES ClientRespondToQuoteResponse(ClientResponseID)
);

CREATE TABLE OrderOfWork (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    RequestID INT,
    ClientID INT,   
    StartDate DATE,
    EndDate DATE,
    Status ENUM('Initiated', 'Finished', 'Underway', 'Undecided'),    
    NumberOfTreesCut INT,
    DateOfCut DATE,
    ContractorID VARCHAR(50),
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID),
    FOREIGN KEY (RequestID) REFERENCES QuoteRequest(RequestID)   
);

CREATE TABLE Bills (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    ContractorID INT,
    OrderID INT,  
    Amount DECIMAL(10, 2),
    GeneratedDate DATE,
    BillStatus ENUM('Issued', 'Pending'),
    PaymentStatus ENUM('Paid', 'Unpaid', 'Overdue'),
    FOREIGN KEY (OrderID) REFERENCES OrderOfWork(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (ContractorID) REFERENCES Contractor(ContractorID) ON DELETE CASCADE
);

CREATE TABLE ResponseToBill (
    ResponseToBillID INT AUTO_INCREMENT PRIMARY KEY,
    BillID INT,
    ClientID INT,
    ResponseDate DATE,
    Note VARCHAR(50),
    PaymentStatus ENUM('Paid', 'Unpaid'),
    FOREIGN KEY (BillID) REFERENCES Bills(BillID) ON DELETE CASCADE,
    FOREIGN KEY (ClientID) REFERENCES Client(ClientID) ON DELETE CASCADE
);



insert into Contractor( Username, Password, Email)
values ( 'david', 'david1234', 'david@gmail.com');

select * from Contractor;

insert into Administrator(Username, Password, Email)
values 
( 'sai', 'sai1234', 'sai@gmail.com');             

select * from administrator;

insert into Client(  FirstName, LastName, Password, Address, CreditCardInfo, PhoneNumber, Email)
values 
('Sina ', 'Riz','susie123', '124 detroit MI 48202','1010101010', '11111', 'sina@gmail.com'),
('Laon', 'Le', 'lawson123', '5678 detroit CO 12561','2020202020', '22222','laon@gmail.com'),
('Brody', 'Pum', 'brady23', '9101 detroit DU 54321','3030303030', '33333','brody@gmail.com'),
('Moore', 'Mon', 'moore123','1121 detroit MI 48202','4040404040', '44444', 'moore@gmail.com'),
('Phil', 'Zip','phillips123','3141 detroit IL 48000','5050505050', '55555', 'phil@gmail.com'),
('Rance', 'Luci','pierce123','5161 detroit CM 24680','6060606060', '66666', 'rance@gmail.com'),
('Franky','Hakin', 'francis123','7181 egypt DT 13579','7070707070', '77777', 'franky@gmail.com'),
('Mish', 'Jo','smith123','9202 signu MH 09876','8080808080', '88888', 'mish@gmail.com'),
('Stone', 'Pirs','stone123','1222 snoop HW 87654','9090909090', '99999', 'stone@gmail.com'),
('Aice', 'Smith', 'alice123', '9101 New York, NY 10001', '1122112211', '12121', 'aice@gmail.com'),
('John', 'Do', 'john123', '5678 Chicago, IL 60601', '2233223322', '23232', 'john@gmail.com'),
('Robert', 'John', 'robert123', '2468 Los Angeles, CA 90001', '3344334433', '34343', 'robert@gmail.com'),
('Emil', 'Clark', 'emily123', '1357  San Francisco, CA 94101', '4455445544', '45454', 'emil@gmail.com'),
('Dan', 'Whit', 'daniel123', '7890 Houston, TX 77001', '5566556655', '56565', 'dan@gmail.com'),
('Meg', 'Mill', 'megan123', '1122 Miami, FL 33101', '6677667766', '67676', 'meg@gmail.com'),
('Chale', 'Dav', 'charlie123', '9922 Seattle, WA 98101', '7788778877', '78787', 'chale@gmail.com');

select* from Client; 

insert into QuoteRequest (ClientID, RequestDate, Note, NumberOfTrees, Size, Height, Location, ProximityToHouse)
values
(1,'2010-01-01', 'notes1', 1, 10, 11.1, 'frontyard', 16.9),
(2,'2011-02-02', 'notes2', 2, 6, 11.2, 'backyard', 15.8),
(3,'2012-03-03', 'notes3', 3, 5, 11.3, 'frontyard', 14.7),
(4,'2013-04-04', 'notes4', 4, 8, 19.4, 'backyard', 7.6),
(5,'2014-05-05', 'notes5', 5, 9, 18.5, 'frontyard', 5.5),
(6,'2015-06-06', 'notes6', 6, 4, 17.6, 'backyard', 9.4),
(7,'2016-07-07', 'notes7', 7, 4, 12.7, 'frontyard', 13.3),
(8,'2017-08-08', 'notes8', 8, 9, 16.8, 'backyard', 11.2),
(9,'2018-09-09', 'notes9', 29, 12, 14.9, 'frontyard', 10.1),
(10, '2019-10-10', 'notes10', 10, 13, 15.8, 'backyard', 9.8),
(11, '2020-11-11', 'notes11', 11, 14, 15.8, 'frontyard', 10.8),
(12, '2021-12-12', 'notes12', 12, 15, 17.8, 'frontyard', 11.8),
(13, '2022-01-01', 'notes13', 13, 16, 29.8, 'frontyard', 12.8),
(14, '2023-02-02', 'notes14', 14, 17, 24.8, 'backyard', 13.8),
(15, '2024-03-03', 'notes15', 15, 18, 32.8, 'frontyard', 14.8),
(16, '2025-04-14', 'notes16', 26, 19, 13.8, 'backyard', 15.8);

select * from QuoteRequest;

insert into QuoteResponse (RequestID, ClientID, ResponseDate, Price, WorkPeriodFrom, WorkPeriodTo, Note) 
values
(1, 1, '2010-01-01', 200, '2010-02-02', '2010-02-12', 'Note1'),
(2, 2, '2011-02-02', 500, '2011-03-03', '2011-03-13', 'Note2'),
(3, 3, '2012-03-03', 200, '2012-04-04', '2012-04-14', 'Note3'),
(4, 4, '2013-04-04', 600, '2013-05-05', '2013-05-15', 'Note4'),
(5, 5, '2014-05-05', 700, '2014-06-06', '2014-06-16', 'Note5'),
(6, 6, '2015-06-06', 800, '2015-07-07', '2015-07-17', 'Note6'),
(7, 7, '2016-07-07', 900, '2016-08-08', '2016-08-18', 'Note7'),
(8, 8, '2017-08-08', 800, '2017-09-09', '2017-09-19', 'Note8'),
(9, 9, '2018-09-09', 1200, '2018-10-10', '2018-10-20', 'Note9'),
(10, 10, '2019-10-10', 300, '2019-11-11', '2019-11-21', 'Note10'), 
(11, 11, '2020-11-11', 1400, '2020-12-12', '2020-12-22', 'Note11'),
(12, 12, '2021-12-12', 1500, '2021-01-13', '2020-02-23', 'Note12'),
(13, 13, '2022-01-11', 1600, '2022-02-02', '2022-02-12', 'Note13'),
(14, 14, '2023-02-12', 1700, '2023-03-03', '2023-03-13', 'Note14'),
(15, 15, '2024-03-13', 1800, '2024-04-04', '2024-04-14', 'Note15'),
(16, 16, '2025-04-14', 1900, '2025-05-05', '2025-05-15', 'Note16');

select * from QuoteResponse;  

insert into ClientRespondToQuoteResponse (ContractorID, ResponseID, ResponseDate, Status, Note)
values 
(1, 1, '2010-01-02', 'Accepted', 'Cut ASAP'), 
(1, 2, '2011-02-03', 'Rejected', 'Cut ASAP'),
(1, 3, '2012-03-04', 'Accepted', 'low cost'),
(1, 4, '2013-04-05', 'RequestAgain', NULL),
(1, 5, '2014-05-06', 'Accepted', 'yuo'),
(1, 6, '2015-06-07', 'Rejected', 'ip'),
(1, 7, '2016-07-08', 'Accepted', NULL),
(1, 8, '2017-08-09', 'RequestAgain', 'kim'),
(1, 9, '2018-09-10', 'Accepted', NULL), 
(1, 10, '2019-10-11', 'Rejected', 'you'), 
(1, 11, '2020-11-12', 'RequestAgain', NULL),
(1, 12, '2021-12-13', 'Accepted', 'try'),
(1, 13, '2022-01-14', 'Rejected', NULL),
(1, 14, '2023-02-15', 'Accepted', 'nov'),
(1, 15, '2024-03-16', 'RequestAgain', NULL), 
(1, 16, '2025-04-17', 'RequestAgain', NULL);

select * from ClientRespondToQuoteResponse;

insert into ContractorRespondToClientResponse (ContractorID, ClientResponseID, Status, ResponseDate, Note, ModifiedPrice, ModifiedWorkPeriodFrom, ModifiedWorkPeriodTo) 
values
(1, 1, 'Accepted', '2010-01-03', 'hi', 700, '2010-02-02', '2010-02-12'),
(1, 3, 'Accepted', '2012-03-05', 'hi', 3000, '2012-04-04', '2012-04-14'),
(1, 4, 'Rejected', '2013-04-06', 'bye', 150, '2013-05-05', '2013-05-15'), 
(1, 5, 'Accepted', '2014-05-07', 'hi', 700, '2014-06-06', '2014-06-16'), 
(1, 7, 'Accepted', '2016-07-09', 'hi', 800, '2016-08-08', '2016-08-18'), 
(1, 8, 'Rejected', '2017-08-10', 'bye', 950, '2017-09-09', '2017-09-19'), 
(1, 9, 'Accepted', '2018-09-11', 'hi', 500, '2018-10-10', '2018-10-20'),
(1, 12, 'Accepted', '2021-12-14', 'hi', 1000, '2021-01-13', '2020-02-23'),
(1, 14, 'Accepted', '2023-02-16', 'hi', 1200, '2023-03-03', '2023-03-13'),
(1, 15, 'Rejected', '2021-12-14', 'hi', 500, '2024-04-04', '2024-04-14'),
(1, 16, 'Accepted', '2021-12-14', 'bye', 1300, '2025-05-05', '2025-05-15');

select * from ContractorRespondToClientResponse;

insert into OrderOfWork (RequestID, ClientID, StartDate , EndDate, Status, NumberOfTreesCut, DateOfCut, ContractorID)
values 
(1, 1, '2010-02-02', '2010-02-12', 'Initiated', 1, '2010-02-12', '1'),
(3, 3, '2012-04-04', '2012-04-14', 'Finished', 3, '2012-04-14', '1'),
(5, 5, '2014-06-06', '2014-06-16', 'Underway', 5, '2014-06-16', '1'),
(7, 7, '2016-08-08', '2016-08-18', 'Undecided', 7, '2016-08-18', '1'),
(9, 9, '2018-10-10', '2018-10-20', 'Initiated', 29, '2018-10-20', '1'),
(12, 12, '2021-01-13', '2020-02-23', 'Initiated', 12, '2020-02-23', '1'),
(14, 14, '2023-03-03', '2023-03-13', 'Finished', 14, '2023-03-13', '1'),
(16, 16, '2025-05-05', '2025-05-15', 'Finished', 26, '2025-05-15', '1')
-- ,(17, 16, '2022-08-02','2022-08-15','Finished',38, '2022-08-14','1') 
-- ,(20, 10, '2022-08-12', '2022-08-25', 'Finished', 24, '2022-08-15', '1') 
;

select * from OrderOfwork;

insert into Bills ( ContractorID, OrderID, Amount, GeneratedDate, BillStatus, PaymentStatus) 
VALUES 
(1, 1, 1000, '2010-02-12', 'Issued', 'Paid'),
(1, 2, 1300, '2012-04-14', 'Issued', 'Paid'),
(1, 3, 5000, '2014-06-16', 'Issued', 'Overdue'),
(1, 4, 700, '2016-08-18', 'Issued', 'Paid'),
(1, 5, 900, '2018-10-20', 'Issued', 'Overdue'),
(1, 6, 1800, '2020-02-23', 'Issued', 'Paid'),  
(1, 7, 2400, '2023-03-13', 'Issued', 'Unpaid')
,(1, 8, 2600, '2021-05-15', 'Issued', 'Overdue')
;

select * from Bills;

INSERT INTO ResponseToBill ( BillID, ClientID, ResponseDate, Note, PaymentStatus) 
VALUES 
(1, 1,'2010-02-12','Thanks', 'Paid'),
(2, 3,'2012-04-14','Thank you', 'Paid'), 
(3, 5,'2015-06-16','Pending work', 'Unpaid'), 
(4, 7,'2016-08-18','good bye', 'Paid'), 
(5, 9,'2019-10-20','thank you', 'Unpaid'), 
(6, 12,'2020-02-23','see ya', 'Paid'), 
(7, 14,'2021-03-13','next time', 'Unpaid')
,(8, 16,'2025-05-15','Tq', 'Unpaid')
;

select * from ResponseToBill;


