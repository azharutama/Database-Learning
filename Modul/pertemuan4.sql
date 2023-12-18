USE master
GO

IF OBJECT_ID('dbo.T1', 'U') IS NOT NULL DROP TABLE dbo.T1;
CREATE TABLE dbo.T1
(
    keycol  INT          NOT NULL IDENTITY (1,1)
        CONSTRAINT PK_T1 PRIMARY KEY,
    datacol NVARCHAR(40) NOT NULL
);

INSERT INTO dbo.T1(datacol)
OUTPUT inserted.Keycol,
       inserted.datacol
SELECT lastname
FROM HR.Employees
WHERE country = N'USA';


IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders
(
    orderid        INT          NOT NULL,
    custid         INT          NULL,
    empid          INT          NOT NULL,
    orderdate      DATETIME     NOT NULL,
    requireddate   DATETIME     NOT NULL,
    shippeddate    DATETIME     NULL,
    shipperid      INT          NOT NULL,
    freight        MONEY        NOT NULL
        CONSTRAINT DFT_Orders_freight DEFAULT (0),
    shipname       NVARCHAR(40) NOT NULL,
    shipaddress    NVARCHAR(60) NOT NULL,
    shipcity       NVARCHAR(15) NOT NULL,
    shipregion     NVARCHAR(15) NULL,
    shippostalcode NVARCHAR(10) NULL,
    shipcountry    NVARCHAR(15) NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (orderid)
);
GO
INSERT INTO dbo.Orders
SELECT *
FROM Sales.Orders;
SELECT *
FROM dbo.Orders;

DELETE
FROM dbo.Orders
OUTPUT deleted.orderid,
       deleted.orderdate,
       deleted.empid,
       deleted.custid
WHERE orderdate < '20080101'

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
CREATE TABLE dbo.OrderDetails
(
    orderid   INT           NOT NULL,
    productid INT           NOT NULL,
    unitprice MONEY         NOT NULL
        CONSTRAINT DFT_OrderDetails_unitprice DEFAULT (0),
    qty       SMALLINT      NOT NULL
        CONSTRAINT DFT_OrderDetails_qty DEFAULT (1),
    discount  NUMERIC(4, 3) NOT NULL
        CONSTRAINT DFT_OrderDetails_discount DEFAULT (0),
    CONSTRAINT PK_OrderDetails PRIMARY KEY (orderid, productid),
    CONSTRAINT CHK_discount CHECK (discount BETWEEN 0 AND 1),
    CONSTRAINT CHK_qty CHECK (qty > 0),
    CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
);
GO

UPDATE dbo.OrderDetails
SET discount += 0.05
OUTPUT inserted.productid, deleted.discount AS olddiscount, inserted.discount AS newdiscount
WHERE productid = 51;

IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO
CREATE TABLE dbo.Customers
(
    custid      INT         NOT NULL,
    companyname VARCHAR(25) NOT NULL,
    phone       VARCHAR(20) NOT NULL,
    address     VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (custid)
);
INSERT INTO dbo.Customers(custid, companyname, phone, address)
VALUES (1, 'cust 1', '(111) 111-1111', 'address 1'),
       (2, 'cust 2', '(222) 222-2222', 'address 2'),
       (3, 'cust 3', '(333) 333-3333', 'address 3'),
       (4, 'cust 4', '(444) 444-4444', 'address 4'),
       (5, 'cust 5', '(555) 555-5555', 'address 5');

IF OBJECT_ID('dbo.CustomersStage', 'U') IS NOT NULL
    DROP TABLE dbo.
        CustomersStage;
GO
CREATE TABLE dbo.CustomersStage
(
    custid      INT         NOT NULL,
    companyname VARCHAR(25) NOT NULL,
    phone       VARCHAR(20) NOT NULL,
    address     VARCHAR(50) NOT NULL,
    CONSTRAINT PK_CustomersStage PRIMARY KEY (custid)
);
INSERT INTO dbo.CustomersStage(custid, companyname, phone, address)
VALUES (2, 'AAAAA', '(222) 222-2222', 'address 2'),
       (3, 'cust 3', '(333) 333-3333', 'address 3'),
       (5, 'BBBBB', 'CCCCC', 'DDDDD'),
       (6, 'cust 6 (new)', '(666) 666-6666', 'address 6'),
       (7, 'cust 7 (new)', '(777) 777-7777', 'address 7');


MERGE INTO dbo.Customers AS TGT
USING dbo.CustomersStage AS SRC
ON TGT.custid = SRC.custid
WHEN MATCHED THEN
    UPDATE
    SET TGT.companyname = SRC.companyname,
        TGT.phone       = SRC.phone,
        TGT.address     = SRC.address
WHEN NOT MATCHED THEN
    INSERT (custid, companyname, phone, address)
    VALUES (SRC.custid, SRC.companyname, SRC.phone, SRC.address)
    OUTPUT $action AS theaction, inserted.custid, deleted.companyname AS oldcompanyname, inserted.companyname AS newcompanyname, deleted.phone AS oldphone, inserted.phone AS newphone, deleted.address AS oldaddress, inserted.address AS newaddress
    ;

IF OBJECT_ID('dbo.ProductsAudit', 'U') IS NOT NULL DROP TABLE dbo.ProductsAudit;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
CREATE TABLE dbo.Products
(
    productid    INT          NOT NULL,
    productname  NVARCHAR(40) NOT NULL,
    supplierid   INT          NOT NULL,
    categoryid   INT          NOT NULL,
    unitprice    MONEY        NOT NULL
        CONSTRAINT DFT_Products_unitprice DEFAULT (0),
    discontinued BIT          NOT NULL
        CONSTRAINT DFT_Products_discontinued DEFAULT (0),
    CONSTRAINT PK_Products PRIMARY KEY (productid),
    CONSTRAINT CHK_Products_unitprice CHECK (unitprice >= 0)
);

INSERT INTO dbo.Products
SELECT *
FROM Production.Products;

CREATE TABLE dbo.ProductsAudit
(
    LSN       INT         NOT NULL IDENTITY PRIMARY KEY,
    TS        DATETIME    NOT NULL DEFAULT (CURRENT_TIMESTAMP),
    productid INT         NOT NULL,
    colname   SYSNAME     NOT NULL,
    oldval    SQL_VARIANT NOT NULL,
    newval    SQL_VARIANT NOT NULL
);

INSERT INTO dbo.ProductsAudit(productid, colname, oldval, newval)
SELECT productid, N'unitprice', oldval, newval
FROM (UPDATE dbo.Products
    SET unitprice *= 1.15 OUTPUT inserted.productid, deleted.unitprice AS oldval, inserted.unitprice AS newval
    WHERE supplierid = 1) AS D
WHERE oldval < 20.0
  AND newval >= 20.0;
SELECT *
FROM dbo.ProductsAudit;
