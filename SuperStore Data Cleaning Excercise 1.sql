-- 1. Establish the relationship between the tables as per the ER diagram.

SELECT * FROM OrdersList
SELECT * FROM EachOrderBreakdown

ALTER TABLE OrdersList
ALTER COLUMN OrderID NVARCHAR(255) NOT NULL

ALTER TABLE OrdersList
ADD CONSTRAINT pk_orderid PRIMARY KEY (OrderID)

ALTER TABLE EachOrderBreakdown
ALTER COLUMN OrderID NVARCHAR(255) NOT NULL

ALTER TABLE EachOrderBreakdown
ADD CONSTRAINT fk_orderid FOREIGN KEY (OrderID) REFERENCES OrdersList (OrderID)

-- 2. Split City State Country into 3 individual columns namely ‘City’, ‘State’, ‘Country’.

ALTER TABLE OrdersList
ADD City nvarchar (255),
	State nvarchar (255),
	Country nvarchar (255);

UPDATE OrdersList
SET City = PARSENAME(REPLACE([City State Country],',','.'),3),
	State = PARSENAME(REPLACE([City State Country],',','.'),2),
	Country = PARSENAME(REPLACE([City State Country],',','.'),1);

ALTER TABLE OrdersList
DROP COLUMN [City State Country]

SELECT * FROM OrdersList

-- 3. Add a new Category Column using the following mapping as per the first 3 characters in the Product Name Column: 
-- a. TEC- Technology 
-- b. OFS – Office Supplies 
-- c. FUR - Furniture.

SELECT * FROM EachOrderBreakdown

ALTER TABLE EachOrderBreakdown
ADD Category nvarchar(255)

UPDATE EachOrderBreakdown
SET Category = CASE WHEN LEFT(ProductName,3) = 'OFS' THEN 'Office Supplies'
					WHEN LEFT(ProductName,3) = 'TEC' THEN 'Technology'
					WHEN LEFT(ProductName,3) = 'FUR' THEN 'Furniture'
				END;

SELECT * FROM EachOrderBreakdown

-- 4. Delete the first 4 characters from the ProductName Column.

UPDATE EachOrderBreakdown
SET ProductName = SUBSTRING(ProductName,5,LEN(ProductName)-4)

SELECT * FROM EachOrderBreakdown

-- 5. Remove duplicate rows from EachOrderBreakdown table, if all column values are matching
WITH CTE AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY OrderID, ProductName, Discount, Sales,
              Profit, Quantity, SubCategory, Category ORDER BY OrderID) AS rn
		FROM EachOrderBreakdown
)
DELETE FROM CTE
WHERE rn > 1

SELECT * FROM EachOrderBreakdown


-- 6. Replace blank with NA in OrderPriority Column in OrdersList table.

SELECT * FROM OrdersList

UPDATE OrdersList
SET OrderPriority = 'NA'
WHERE OrderPriority = ' ';

SELECT * FROM OrdersList


