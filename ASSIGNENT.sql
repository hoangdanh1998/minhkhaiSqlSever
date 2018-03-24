create database [minhkhai.com.vn]
go
use [minhkhai.com.vn]
go
CREATE TABLE Employee
(
  EmpID VARCHAR(30) NOT NULL,
  Name NVARCHAR(30) NOT NULL,
  Email VARCHAR(30) NOT NULL,  
  Address NVARCHAR(30) NOT NULL,
  PhoneNumber VARCHAR(11) NOT NULL,  
  PRIMARY KEY (EmpID)
);


CREATE TABLE Member
(
  MemberID VARCHAR(30) NOT NULL,
  Name NVARCHAR(30) NOT NULL,
  Address NVARCHAR(30) NOT NULL,
  Gender NVARCHAR(10) NOT NULL, 
  BirthDate DATE NOT NULL,
  Email VARCHAR(30) NOT NULL,
  PhoneNumber VARCHAR(30) NOT NULL,
  PRIMARY KEY (MemberID)
);

CREATE TABLE [Order]
(
  BookCode VARCHAR(30) NOT NULL,
  MemberID VARCHAR(30) NOT NULL,
  EmpID VARCHAR(30) NOT NULL,
  Amount INT NOT NULL,
  Cost INT NOT NULL,
  PRIMARY KEY (MemberID, EmpID),
  FOREIGN KEY (MemberID) REFERENCES Member(MemberID),
  FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);


CREATE TABLE Book
(
  BookCode VARCHAR(30) NOT NULL,
  Name NVARCHAR(30) NOT NULL,
  EmpID VARCHAR(30) NOT NULL,  
  Price INT NOT NULL,  
  PriceDiscount INT	 NOT NULL,  
  UploadDate DATE NOT NULL,  
  PRIMARY KEY (BookCode),
  FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);


---insert---
INSERT INTO
  Book(BookCode, Name, EmpID, Price, PriceDiscount,UploadDate)
VALUES
  ('DBI','Database','Employee01',20000,0,'20180324 10:34:09 AM'),
  ('JXS','Java','Employee02',18000,0,'20180324 10:34:09 AM'),
  ('JS','JavaScript','Employee03',9000,0,'20180324 10:34:09 AM')
GO
INSERT INTO
  [Order](BookCode, EmpID,MemberID, Amount, Cost)
VALUES
  ('DBI','Employee01', 'Volam2258948', 9, 200000),
  ('JS','Employee02', 'spamer01', 1, 18000),
  ('JXS','Employee03', 'spamer01', 2, 18000)
GO
INSERT INTO
  MEMBER(MemberID, Name, Email, Gender, BirthDate, Address, PhoneNumber)
VALUES
  ('Volam2258948', N'Nguyễn Hoàng Danh', 'danhnhse63365@gmail.com',  'Nam', '20120618 10:34:09 AM', N'Việt Nam', '0954567891'),
  ('dokidoki',  N'Doki-chan', 'Dokiachan@doridori.com',       'Nữ', '20120618 10:34:09 AM', N'Nhật Bản', '0954567892'),
  ('phqb',      N'Bảo BT', 'lucyuknowhat@gmail.com',          'Nam', '20120618 10:34:09 AM', N'Hàn Quốc', '0954567893'),
  ('bbd.mid',   N'Bảo ĐD', 'justrandomname@gmail.com',         'Nam', '20120618 10:34:09 AM', N'Nhật Bản', '0954567894'),
  ('spamer01',  N'Thành viên 01', 'thanhvien01@email.com',     'Nam', '20120618 10:34:09 AM', N'Nhật Bản', '0954567895'),
  ('spamer02',  N'Thành viên 02', 'thanhvien02@email.com',     'Nam', '20120618 10:34:09 AM', N'Nhật Bản', '0954567896'),
  ('spamer03',  N'Thành viên 03', 'thanhvien03@email.com',     'Nữ', '20120618 10:34:09 AM', N'Nhật Bản', '0954567897')
GO
INSERT INTO
  Employee(EmpID, Name, Email, Address, PhoneNumber)
VALUES
  ('Employee01', N'Người Kiểm Duyệt 01', 'email1@email.com', N'Việt Nam', '01234567891'),
  ('Employee02', N'Người Kiểm Duyệt 02', 'email2@email.com', N'Việt Nam', '01234567892'),
  ('Employee03', N'Người Kiểm Duyệt 03', 'email3@email.com', N'Việt Nam', '01234567893'),
  ('Employee04', N'Người Kiểm Duyệt 04', 'email4@email.com', N'Việt Nam', '01234567894'),
  ('Employee05', N'Người Kiểm Duyệt 05', 'email5@email.com', N'Việt Nam', '01234567895'),
  ('Employee06', N'Người Kiểm Duyệt 06', 'email6@email.com', N'Việt Nam', '01234567896')
GO
---Trigger---
-- Phone
CREATE TRIGGER PhoneNumberEMPLOYEETrigger ON [EMPLOYEE]
AFTER
  INSERT, UPDATE
AS
    DECLARE @PhoneNumber VARCHAR(11)
    SELECT @PhoneNumber = PhoneNumber
    FROM inserted
    IF (@PhoneNumber LIKE '%[^0-9]%' OR LEN(@PhoneNumber) < 10 OR LEN(@PhoneNumber) > 11)
        BEGIN
            RAISERROR ('Invalid Phone Number', 16, 1)
            ROLLBACK TRANSACTION
        END
GO
CREATE TRIGGER PhoneNumberMemberTrigger ON [Member]
AFTER
  INSERT, UPDATE
AS
    DECLARE @PhoneNumber VARCHAR(11)
    SELECT @PhoneNumber = PhoneNumber
    FROM inserted
    IF (@PhoneNumber LIKE '%[^0-9]%' OR LEN(@PhoneNumber) < 10 OR LEN(@PhoneNumber) > 11)
        BEGIN
            RAISERROR ('Invalid Phone Number', 16, 1)
            ROLLBACK TRANSACTION
        END
GO
--Email
CREATE TRIGGER Email_Employee_Trigger ON [Employee]
AFTER
  INSERT, UPDATE
AS
    DECLARE @email CHAR(30)
    SELECT @email = Email
    FROM inserted
    IF (@email NOT LIKE '%_@__%.__%')
        BEGIN
            RAISERROR ('Invalid Email', 16, 1)
            ROLLBACK TRANSACTION
        END
GO
CREATE TRIGGER Email_Member_Trigger ON [Member]
AFTER
  INSERT, UPDATE
AS
    DECLARE @email CHAR(30)
    SELECT @email = Email
    FROM inserted
    IF (@email NOT LIKE '%_@__%.__%')
        BEGIN
            RAISERROR ('Invalid Email', 16, 1)
            ROLLBACK TRANSACTION
        END
GO
CREATE TRIGGER GenderMEMBERTrigger ON [MEMBER]
AFTER
  INSERT, UPDATE
AS
    DECLARE @gender NVARCHAR(30)
    SELECT @gender = Gender
    FROM inserted
    IF (@gender NOT IN (N'Nam', N'Nữ', N'Chưa biết'))
        BEGIN
            RAISERROR ('Invalid Gender', 16, 1)
            ROLLBACK TRANSACTION
        END
GO

--Price
CREATE TRIGGER ValidPriceBookTrigger ON Book
AFTER
  INSERT, UPDATE
AS
    DECLARE @price INT, @priceDiscount INT, @Message VARCHAR(MAX)
    SELECT @price = Price, @priceDiscount = PriceDiscount
    FROM inserted
    IF (@priceDiscount IS NOT NULL AND @price <= @priceDiscount)
        BEGIN
			SET @Message = 'Invalid Discount = <' + CAST(@priceDiscount AS VARCHAR(10)) + '>, Origin = <' + CAST(@price AS VARCHAR(10)) + '> ?';
            RAISERROR (@Message, 16, 1)
            ROLLBACK TRANSACTION
        END
GO
--Amount > 0
CREATE TRIGGER Amount_Order On [Order]
AFTER 
	INSERT, UPDATE
AS 
	DECLARE @Amount int
	SELECT @Amount = Amount 
	From inserted
	if (@Amount <0)
		BEGIN
			print('Amount must be Positive integer');
            ROLLBACK TRANSACTION
		END
Go			
drop trigger Amount_Order		
--Query
--Print all Book
Select * from Book

--Find book
DECLARE @name NVARCHAR(30)
SET @name = N'Database' -- Từ khóa người dùng nhập vào
SELECT *
FROM Book
WHERE Name = @name
-- View all your orders
DECLARE @memberID_ord CHAR(30)
SET @memberID_ord = 'Volam2258948' -- Your Member.ID
SELECT *
FROM [Order]
WHERE MemberID = @memberID_ord;


drop table Book
drop table [Order]
drop table Employee
drop table Member
