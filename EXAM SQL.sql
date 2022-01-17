--1 tạo cơ sở dữ liệu
CREATE DATABASE AZBank
GO

USE AZBank
GO

--2 tạo bảng 
CREATE TABLE Customer(
CustomerID int PRIMARY KEY NOT NULL,
Name nvarchar(50) NULL,
City nvarchar(50) NULL,
Country nvarchar(50) NULL,
Phone nvarchar(15) NULL,
Email nvarchar(50) NULL
)
GO

CREATE TABLE CustomerAccount(
AccountNumber char(9) PRIMARY KEY NOT NULL,
CustomerID int FOREIGN KEY REFERENCES dbo.Customer(CustomerID) NOT NULL,
Balance money NOT NULL,
MinAccount money NULL
)
GO

CREATE TABLE CustomerTransaction(
TransactionID int PRIMARY KEY NOT NULL,
AccountNumber char(9) FOREIGN KEY REFERENCES dbo.CustomerAccount(AccountNumber) NULL,
TransactionDate smalldatetime NULL,
Amount money NULL,
DepositorWithdraw bit NULL
)
GO

--3 chèn dữ liệu
--Customer(ID,Name,City,Country,Phone,Email)
INSERT INTO Customer VALUES(1,N'Lê Tuấn Minh',N'Hà Nội',N'Việt Nam',N'+84-3214565',N'leeminhtuanoo@gmail.com'),
						   (2,N'Nguyễn Văn An',N'Hà Nội', N'Việt Nam', N'+84-3217890',N'nguyenan@gmail.com'),
						   (3,N'Phạm Văn Bình',N'Đà Lạt', N'Việt Nam', N'+84-3216543',N'binhpham@gmail.com')

SELECT * FROM Customer
GO

--CustomerAccount(AccountNumber,CustomerID,Balance,MinAccount)
INSERT INTO CustomerAccount VALUES(30112003,1,1000000000,50000),
								  (29019382,2,10000000000,50000),
								  (99999999,3,900000000,50000)

SELECT * FROM CustomerAccount
GO

--CustomerTransaction(ID,AccountNumber,TransactionDate,Amount,DepositorWithdraw)
INSERT INTO CustomerTransaction VALUES(1,30112003,'20210215',100000000,0),
									  (2,29019382,'20220101',1000000,1),
									  (3,99999999,'20203011',5000000,1)

SELECT * FROM CustomerTransaction
GO

--4 truy vấn khách hàng ở Hà Nội 
SELECT * FROM Customer WHERE City LIKE N'Hà Nội'
GO

--5 truy vấn thông tin tài khoản khách hàng
SELECT Name,Phone, Email, AccountNumber,Balance FROM Customer
JOIN CustomerAccount 
ON CustomerAccount.CustomerID = Customer.CustomerID 
GO

--6 quy tắc kinh doanh 
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_MONEY
CHECK ( Amount > 0 AND Amount <= 1000000)
GO

--7  tạo view
CREATE VIEW vCustomerTransactions
AS
SELECT Name, CustomerAccount.AccountNumber,TransactionDate,Amount ,CustomerTransaction.DepositorWithdraw FROM Customer
JOIN CustomerAccount
ON CustomerAccount.CustomerID = Customer.CustomerID
JOIN CustomerTransaction
ON CustomerTransaction.AccountNumber = CustomerAccount.AccountNumber