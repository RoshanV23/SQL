-- Data Exploration
--1. List the top 10 orders with the highest sales from the EachOrderBreakdown table.

SELECT TOP 10 * 
FROM EachOrderBreakdown
ORDER BY Sales DESC

--2. Show the number of orders for each product category in the EachOrderBreakdown table.

 SELECT Category, COUNT(*) AS NoOfOrders
 FROM EachOrderBreakdown 
 GROUP BY Category


-- 3. Find the total profit for each sub-category in the EachOrderBreakdown table.

SELECT SubCategory, SUM(Profit) AS TotalProfit
 FROM EachOrderBreakdown 
 GROUP BY SubCategory

 -- 4. Identify the customer with the highest total sales across all orders.

SELECT * 
FROM OrdersList
SELECT * 
FROM EachOrderBreakdown

SELECT TOP 1 CustomerName, SUM(Sales) AS TotalSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY CustomerName
ORDER BY TotalSales DESC


-- 5. Find the month with the highest average sales in the OrdersList table.

SELECT * 
FROM OrdersList
SELECT * 
FROM EachOrderBreakdown

SELECT TOP 1 MONTH(OrderDate) AS Month, AVG(Sales) AS AVGSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY MONTH(OrderDate)
ORDER BY AVGSales DESC


-- 6. Find out the average quantity ordered by customers whose first name starts with an alphabet 's'?

SELECT * 
FROM OrdersList
SELECT * 
FROM EachOrderBreakdown

SELECT AVG(Quantity) AS AVGQty
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
WHERE LEFT(CustomerName,1) = 'S'


-- 7. Find out how many new customers were acquired in the year 2014?

SELECT * 
FROM OrdersList

SELECT COUNT(*) AS NewCustomers2014 FROM (
SELECT CustomerName, MIN(OrderDate) AS FirstOrderDate
FROM OrdersList
Group BY CustomerName
Having YEAR(MIN(OrderDate)) = '2014') AS NoOFNewCustomers


-- 8. Calculate the percentage of total profit contributed by each sub-category to the overall profit.

SELECT SubCategory, SUM(Profit) AS SubCatgProfit,
SUM(Profit)/(SELECT SUM(Profit) FROM EachOrderBreakdown) * 100 AS PerctTotal
FROM EachOrderBreakdown
GROUP BY SubCategory

-- 9. Find the average sales per customer, considering only customers who have made more than one order.

WITH CustomerAvgSales AS (
SELECT CustomerName, COUNT(DISTINCT ol.OrderID) AS NoofOrders, AVG(Sales) AS AVGSales
FROM OrdersList ol
JOIN EachOrderBreakdown ob
ON ol.OrderID = ob.OrderID
GROUP BY CustomerName
)
SELECT CustomerName, AVGSales
FROM CustomerAvgSales
WHERE NoofOrders > 1


-- 10. Identify the top-performing subcategory in each category based on total sales. Include the subcategory name, total sales, and a ranking of sub-category within each category.

WITH Topsubcategory AS(
SELECT Category, SubCategory, SUM(Sales) AS TotalSales,
RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS SubCatRank
FROM EachOrderBreakdown
GROUP BY Category, SubCategory
)
SELECT *
FROM Topsubcategory
WHERE SubCatRank = 1


