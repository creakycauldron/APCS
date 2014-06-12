-- This example is taken from MSDN:
-- http://technet.microsoft.com/en-us/library/ms186243%28v=sql.105%29.aspx
-- Create an Employee table.
CREATE TABLE dbo.MyEmployees
(
	EmployeeID smallint NOT NULL,
	FirstName nvarchar(30)  NOT NULL,
	LastName  nvarchar(40) NOT NULL,
	Title nvarchar(50) NOT NULL,
	DeptID smallint NOT NULL,
	ManagerID int NULL,
 CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC) 
);
-- Populate the table with values.
INSERT INTO dbo.MyEmployees VALUES 
	(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL),
	(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1),
	(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273),
	(275, N'Michael', N'Blythe', N'Sales Representative',3,274),
	(276, N'Linda', N'Mitchell', N'Sales Representative',3,274),
	(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273),
	(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285),
	(16,  N'David',N'Bradley', N'Marketing Manager', 4, 273),
	(23,  N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);


WITH DirectReports (ManagerID, EmployeeID, Title, DeptID, Level)
(-- Anchor member definition
-- Starts from the employees at the highest level.
	SELECT	e.ManagerID, e.EmployeeID, e.Title, e.Deptid,
					0 AS Level
	FROM dbo.MyEmployees e
	WHERE e.ManagerID IS NULL
	UNION ALL
-- Recursive member definition
	SELECT	E.ManagerID, E.EmployeeID, E.Title, E.Deptid,
					Level + 1
	FROM	dbo.MyEmployees AS E
				INNER JOIN DirectReports AS D
				ON E.ManagerID = D.EmployeeID
)
-- Statement that executes the CTE
SELECT ManagerID, EmployeeID, Title, Level
FROM DirectReports
-- The rows in the resulting table would correspond to the branches of the tree that represent employee levels.
