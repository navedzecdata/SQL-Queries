--A simple stored procedure to return all customers from the Customers table.

CREATE PROCEDURE GetAllCustomers
AS
BEGIN
    SELECT * FROM Customers;
END;

--Execution

EXEC GetAllCustomers;

--A stored procedure to get orders for a specific customer.

CREATE PROCEDURE GetCustomerOrders @CustomerID NVARCHAR(5)
AS
BEGIN
    SELECT * 
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;
 
--Execution

EXEC GetCustomerOrders @CustomerID = 'ALFKI';

--Using an OUTPUT Parameter

CREATE PROCEDURE GetOrderCount
    @CustomerID NVARCHAR(5),
    @OrderCount INT OUTPUT
AS
BEGIN
    SELECT @OrderCount = COUNT(*)
    FROM Orders
    WHERE CustomerID = @CustomerID;
END;


--Execution

DECLARE @Count INT;
EXEC GetOrderCount @CustomerID = 'ALFKI', @OrderCount = @Count OUTPUT;
PRINT @Count; -- Outputs the total order count

--using return


CREATE PROCEDURE CheckProductStock
    @ProductID INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Products WHERE ProductID = @ProductID AND UnitsInStock > 0)
        RETURN 1; -- Product in stock
    ELSE
        RETURN 0; -- Product not in stock
END;


--Execution

DECLARE @Status INT;
EXEC @Status = CheckProductStock @ProductID = 1;
PRINT @Status; 


--A UDF that calculates the total order amount for a given order ID and returns value.



CREATE FUNCTION GetOrderTotal
    (@OrderID INT)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Total DECIMAL(18, 2);
    SELECT @Total = SUM(UnitPrice * Quantity * (1 - Discount))
    FROM [Order Details]
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;

--Execution

SELECT dbo.GetOrderTotal(10248) AS TotalAmount;

