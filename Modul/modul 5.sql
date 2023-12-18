USE master
GO

IF OBJECT_ID('dbo.GetAge') IS NOT NULL DROP FUNCTION dbo.GetAge;
GO
CREATE FUNCTION dbo.GetAge(
    @birthdate AS DATE,
    @eventdate AS DATE
)
    RETURNS INT
AS
BEGIN
    RETURN
            DATEDIFF(year, @birthdate, @eventdate)
            - CASE
                  WHEN 100 * MONTH(@eventdate) + DAY(@eventdate)
                      < 100 * MONTH(@birthdate) + DAY(@birthdate)
                      THEN 1
                  ELSE 0
                END;
END;
GO

SELECT empid,
       firstname,
       lastname,
       birthdate,
       dbo.GetAge(birthdate, SYSDATETIME())
           AS age
FROM HR.Employees

IF OBJECT_ID('Sales.GetCustomerOrders', 'P') IS NOT NULL
    DROP PROC Sales.GetCustomerOrders;
GO
CREATE PROC Sales.GetCustomerOrders @custid AS INT,
                                    @fromdate AS DATETIME = '19000101',
                                    @todate AS DATETIME = '99991231',
                                    @numrows AS INT OUTPUT
AS
    SET NOCOUNT ON;
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE custid = @custid
  AND orderdate >= @fromdate
  AND orderdate < @todate;
    SET @numrows = @@rowcount;
GO

DECLARE @rc AS INT;

EXEC Sales.GetCustomerOrders
     @custid = 1,
     @fromdate = '20070101',
     @todate = '20080101',
     @numrows = @rc OUTPUT;

SELECT @rc AS numrows;


-----Muhammad Azhar Utama-----
-----223040077----------------

---------------Tugas 1------------------
IF OBJECT_ID('dbo.IncDiscount', 'FN') IS NOT NULL
    DROP FUNCTION dbo.IncDiscount;
GO
CREATE FUNCTION dbo.IncDiscount(@orderid INT, @unitprice INT, @qty INT)
    RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @discount DECIMAL(5, 2);

    SET @discount =
            CASE
                WHEN @orderid > 0
                    THEN @unitprice * @qty * 0.10
                ELSE 0.00
                END;
    RETURN @discount;
END;
GO
SELECT dbo.IncDiscount(1, 100, 5) AS Discount;


------Tugas 2--------
IF OBJECT_ID('dbo.GetCustomerOrders', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetCustomerOrders;
GO
Use master
Go
CREATE FUNCTION dbo.GetCustomerOrders
    (@orderid INT)
RETURNS TABLE
AS
RETURN
(
    SELECT p.productname, od.qty
    FROM dbo.OrderDetails od
    JOIN dbo.Products p ON od.productid = p.productid
    WHERE od.orderid = @orderid
);
GO

----Memasukan value ke orderdetails karena pada teble ini tidak memiliki value----
insert into dbo.OrderDetails (orderid, productid,unitprice,qty)
values (1,1,20.7000,3)

SELECT * FROM dbo.GetCustomerOrders(1);
