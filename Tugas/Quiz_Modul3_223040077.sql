USE master
GO
---quiz 1---
---MUHAMMD AZHAR UTAMA---
SELECT custid,
       orderid,
       qty,
       RANK() OVER (PARTITION BY custid ORDER BY qty)       AS rank,
       DENSE_RANK() OVER (PARTITION BY custid ORDER BY qty) AS drnk

FROM dbo.Orders
ORDER BY custid,qty;

---quiz 2---
---MUHAMMD AZHAR UTAMA---
SELECT
    empid,
    COUNT(CASE WHEN YEAR(orderdate) = 2007 THEN 1 END) AS cnt2007,
    COUNT(CASE WHEN YEAR(orderdate) = 2008 THEN 1 END) AS cnt2008,
    COUNT(CASE WHEN YEAR(orderdate) = 2009 THEN 1 END) AS cnt2009
FROM
    dbo.orders
GROUP BY
    empid;

---quiz 3---
---MUHAMMD AZHAR UTAMA---
SELECT
    GROUPING_ID(empid, custid, YEAR(orderdate)) AS groupingset,
    empid,
    custid,
    YEAR(orderdate) AS orderyear,
    SUM(qty) AS sumqty
FROM
    dbo.Orders
GROUP BY
    GROUPING SETS (
        (empid, custid, YEAR(orderdate)),
        (empid, YEAR(orderdate)),
        (custid, YEAR(orderdate)),
        (YEAR(orderdate))
    );


SELECT
