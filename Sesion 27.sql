CREATE DATABASE MINIPROJECT_GAMBLING;
USE MINIPROJECT_GAMBLING;

CREATE TABLE Account (
AccountNo VARCHAR(10) PRIMARY KEY,
CustId INT,
AccountLocation VARCHAR(50),
CurrencyCode CHAR(3),
DailyDepositLimit DECIMAL(10,2),
StakeScale DECIMAL(3,2),
SourceProd VARCHAR(5));

CREATE TABLE Customer (
CustId INT PRIMARY KEY,
AccountLocation VARCHAR(50),
Title VARCHAR(50),
FirstName VARCHAR(100),
LastName VARCHAR(100),
CreateDate DATE,
CountryCode CHAR(2),
Language CHAR(2),
Status CHAR(1),
DateOfBirth DATE,
Contact CHAR(1),
CustomerGroup VARCHAR(20));

CREATE TABLE Betting (
AccountNo VARCHAR(10),
BetDate DATE,
ClassId VARCHAR(20),
CategroyId INT,
Source VARCHAR(5),
BetCount INT,
Bet_Amt DECIMAL(10,2),
Win_Amt DECIMAL(10,2),
Product VARCHAR(20));

CREATE TABLE Product (
ClassId VARCHAR(20) PRIMARY KEY,
CategoryId INT,
Product VARCHAR(50),
Sub_product VARCHAR(50),
Description VARCHAR(200),
Bet_or_play TINYINT);

INSERT INTO account (AccountNo, CustId, AccountLocation, CurrencyCode, DailyDepositLimit, StakeScale, SourceProd) 
VALUES 
('00357DG',3531845,'GIB','GBP',0,1,'GM'),
('00497XG',4188499,'GIB','GBP',0,1,'SB'),
('00692VS',4704925,'GIB','USD',0,2,'SB'),
('00775SM','2815836','GIB','USD',0,1,'SB'),
('00C017',889782,'GIB','GBP',1500,0.41,'XX'),
('00J381',1191874,'GIB','GBP',500,8,'XX'),
('01148BP',1569944,'GIB','GBP',0,8,'XX'),
('01152SJ',1965214,'GIB','USD',0,1,'PO'),
('01196ZZ',3042166,'GIB','EUR',0,8,'SB'),
('01284UW',5694730,'GIB','GBP',0,1,'SB');

select * from account;

INSERT INTO customer (CustId, AccountLocation, Title, FirstName, LastName, CreateDate, CountryCode, Language, Status, DateOfBirth, Contact, CustomerGroup) VALUES 
(4188499, 'GIB', 'Mr', 'Elvis', 'Presley', '2011/01/11', 'US', 'en', 'A', '1948/10/18', 'Y', 'Bronze'), 
(1191874, 'GIB', 'Mr', 'Jim', 'Morrison', '2008/09/19', 'US', 'en', 'A', '1967/07/27', 'Y', 'Gold'), 
(3042166, 'GIB', 'Mr', 'Keith', 'Moon', '2011/01/11', 'UK', 'en', 'A', '1970/07/26', 'Y', 'Gold'),  
(5694730, 'GIB', 'Mr', 'James', 'Hendrix', '2012/10/10', 'US', 'en', 'A', '1976/04/05', 'N', 'Bronze'), 
(4704925, 'GIB', 'Mr', 'Marc', 'Bolan', '2012/03/26', 'UK', 'en', 'A', '1982/03/11', 'Y', 'Bronze'), 
(1569944, 'GIB', 'Miss', 'Janice', 'Joplin', '2009/04/09', 'US', 'en', 'A', '1954/08/22', 'Y', 'Gold'), 
(3531845, 'GIB', 'Mr', 'Bon', 'Scott', '2011/04/02', 'AU', 'en', 'A', '1975/10/22', 'N', 'Silver'), 
(2815836, 'GIB', 'Mr', 'Buddy', 'Holly', '2010/10/17', 'US', 'en', 'A', '1964/01/13', 'Y', 'Silver'), 
(889782, 'GIB', 'Mr', 'Bob', 'Marley', '2008/01/16', 'UK', 'en', 'A', '1964/04/18', 'Y', 'Silver'), 
(1965214, 'GIB', 'Mr', 'Sidney', 'Vicious', '2009/12/18', 'UK', 'en', 'A', '1976/08/12', 'N', 'Bronze');

select * from customer;

select * from betting;

select * from product;

select * from account;

--- 1
select Title, FirstName, LastName, DateOfBirth FROM customer;

--- 2
SELECT CustomerGroup, COUNT(*) AS customer_numbers
FROM customer
GROUP BY CustomerGroup;

--- 3
SELECT customer.*, Account.CurrencyCode
FROM customer
JOIN account ON customer.CustId = account.CustId;

--- 4
SELECT p.product, b.betdate, SUM(b.bet_amt) AS TotalBetAmount
FROM betting AS b
JOIN product AS p ON b.classid = p.classid AND b.CategroyId = p.CategoryId
GROUP BY p.product, b.betdate
ORDER BY p.product, b.betdate;

--- 5
SELECT p.Product, b.BetDate, SUM(b.bet_amt) AS TotalBetAmount
FROM betting AS b
JOIN product AS p ON b.classid = p.classid AND b.CategroyId = p.CategoryId
WHERE b.betdate >= '2012-11-01' AND p.CategoryId = 'Sportsbook'
GROUP BY p.product, b.betdate
ORDER BY p.product, b.betdate;

--- 6
SELECT p.Product, a.CurrencyCode, c.CustomerGroup, SUM(b.bet_amt) AS TotalBetAmount, SUM(b.Win_Amt) AS TotalWinningAmount
FROM betting AS b
JOIN account AS a ON b.AccountNo = a.AccountNo
JOIN customer AS c ON a.CustId = c.CustId
JOIN product AS p ON b.classid = p.classid AND b.CategroyId = p.CategoryId
WHERE b.betdate > '2012-12-01'
GROUP BY p.Product, a.CurrencyCode, c.CustomerGroup
ORDER BY a.CurrencyCode, c.CustomerGroup, p.Product;

--- 7
SELECT c.Title, c.FirstName, c.LastName, COALESCE(SUM(b.Bet_Amt), 0) AS Total_Bet_Amount
FROM Customer AS c
LEFT JOIN Account AS a ON c.CustId = a.CustId
LEFT JOIN Betting AS b ON a.AccountNo = b.AccountNo AND b.BetDate BETWEEN '2012-11-01' AND '2012-11-30' 
GROUP BY c.CustId, c.Title, c.FirstName, c.LastName
ORDER BY c.LastName, c.FirstName;

--- 8.1
SELECT c.Title, c.FirstName, c.LastName, COUNT(DISTINCT p.Product) AS NumberOfProducts
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
GROUP BY c.CustId, c.Title, c.FirstName, c.LastName
ORDER BY NumberOfProducts DESC;

--- 8.2
SELECT c.Title, c.FirstName, c.LastName
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
WHERE p.Product IN ('Sportsbook', 'Vegas')
GROUP BY c.CustId, c.Title, c.FirstName, c.LastName
HAVING COUNT(DISTINCT p.Product) = 2;

--- 9
SELECT c.Title, c.FirstName, c.LastName, SUM(b.Bet_Amt) AS Total_Bet_Amount
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
WHERE b.Bet_Amt > 0
GROUP BY c.CustId, c.Title, c.FirstName, c.LastName
HAVING 
COUNT(DISTINCT p.Product) = 1 AND 
MAX(p.Product) = 'Sportsbook';

--- 10.1
SELECT c.Title, c.FirstName, c.LastName, p.Product, TotalBetAmount
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
JOIN (SELECT a.CustId, p.Product, SUM(b.Bet_Amt) AS TotalBetAmount
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
GROUP BY a.CustId, p.Product) AS ProductSums ON a.CustId = ProductSums.CustId AND p.Product = ProductSums.Product
WHERE ProductSums.TotalBetAmount = (
SELECT MAX(TotalBetAmount)
FROM (SELECT a.CustId, p.Product, SUM(b.Bet_Amt) AS TotalBetAmount
FROM Customer AS c
JOIN Account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
GROUP BY a.CustId, p.Product) AS MaxProductSums
WHERE MaxProductSums.CustId = a.CustId)
ORDER BY c.LastName, c.FirstName;

--- 10.2
WITH PlayerBets AS (SELECT c.Title, c.FirstName, c.LastName, p.Product, SUM(b.Bet_Amt) AS TotalBetAmount,
ROW_NUMBER() OVER (PARTITION BY c.CustId ORDER BY SUM(b.Bet_Amt) DESC) AS rn
FROM Customer AS c
JOIN account AS a ON c.CustId = a.CustId
JOIN Betting AS b ON a.AccountNo = b.AccountNo
JOIN Product AS p ON b.ClassId = p.ClassId AND b.CategroyId = p.CategoryId
GROUP BY c.CustId, c.Title, c.FirstName, c.LastName, p.Product)
SELECT Title, FirstName, LastName, Product, TotalBetAmount
FROM PlayerBets
WHERE rn = 1
ORDER BY LastName, FirstName;

--- 11
CREATE TABLE Student (
student_id INT PRIMARY KEY,
student_name VARCHAR(50),
city VARCHAR(50),
school_id INT,
GPA decimal(3,1));

CREATE TABLE School (
school_id INT PRIMARY KEY,
school_name VARCHAR(50),
city VARCHAR(50));

INSERT INTO Student (student_id, student_name, city, school_id, GPA)
VALUES (1001, 'Peter Brebec', 'New York', 1, 4),
(1002, 'John Goorgy', 'San Francisco', 2, 3.1),
(2003, 'Brad Smith', 'New York', 2, 2.9),
(1004, 'Fabian Johns', 'Boston', 5, 2.1),
(1005, 'Brad Cameron', 'Stanford', 1, 2.3),
(1006, 'Geoff Firby', 'Boston', 5, 1.2),
(1007, 'Johnny Blue', 'New Haven', 2, 3.8),
(1008, 'Johse Brook', 'Miami', 2, 3.4);

INSERT INTO School (school_id, school_name, city)
VALUES (1, 'Stanford', 'Stanford'),
(2, 'University of California', 'San Francisco'),
(3, 'Harvard University', 'New York'),
(4, 'MIT', 'Boston'),
(5, 'Yale', 'New Haven'),
(6, 'University of Westminster', 'London'),
(7, 'Corvinus University', 'Budapest');

SELECT * FROM student
ORDER BY GPA DESC
LIMIT 5;

--- 12
SELECT s.school_name, COUNT(st.student_id) AS num_students
FROM school AS s
LEFT JOIN student AS st ON s.school_id = st.school_id
GROUP BY s.school_id, s.school_name;

--- 13
SELECT school_name, student_name
FROM (SELECT s.school_name, st.student_name, st.GPA,
ROW_NUMBER() OVER (partition by s.school_id ORDER BY st.GPA DESC) AS rn
FROM student AS st
JOIN school AS s ON st.school_id = s.school_id) AS ranked
WHERE rn <= 3;