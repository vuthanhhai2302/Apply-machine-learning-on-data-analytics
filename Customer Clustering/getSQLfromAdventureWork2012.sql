/****** Script for SelectTopNRows command from SSMS  ******/
SELECT PersonID,
	   PersonType,
	   AddressTypeName,
	   AddressLine1,
	   AddressLine2,
	   City,
	   StateProvinceCode,
	   StateName,
	   TerritoryName,
	   CountryRegionCode,
	   CountryName,
	   OrderCount,
	   TotalSpent
FROM (
	SELECT "Customer".[CustomerID],
		   [PersonID],
		   TotalSpent,
		   OrderCount
	FROM 
	[AdventureWorks2012].[Sales].[Customer] as "Customer"
	left join (
		SELECT CustomerID,
			   SUM(TotalDue) as "TotalSpent",
			   Count(*) as "OrderCount"
		FROM 
		[AdventureWorks2012].[Sales].[SalesOrderHeader]
		GROUP BY "CustomerID"
	) as "Sale"
	on "Customer".CustomerID = "Sale".CustomerID
) as "Customer"
right join (
	SELECT "Person".BusinessEntityID,
		   PersonType,
		   AddressTypeName,
		   AddressLine1,
		   AddressLine2,
		   City,
		   StateProvinceCode,
		   StateName,
		   TerritoryName,
		   CountryRegionCode,
		   CountryName
	FROM 
	[Person].[Person] as "Person"
	left join 
	(
		SELECT "BusinessEntity".BusinessEntityID,
				"BusinessEntity".AddressID,
				"BusinessEntity".AddressTypeID,
				"AddressType"."Name" as "AddressTypeName",
				AddressLine1,
				AddressLine2,
				City,
				StateProvinceID
		FROM (
			[AdventureWorks2012].[Person].[BusinessEntityAddress] as "BusinessEntity"
			left join 
			[Person].[AddressType] as "AddressType"
			on "BusinessEntity".AddressTypeID = "AddressType".AddressTypeID
			)
			left join 
			[Person].[Address] as "Address"
			on "BusinessEntity".AddressID = "Address".AddressID
	) as "Address"
	on "Person".BusinessEntityID = "Address".BusinessEntityID
	left join (
		SELECT StateProvinceID,
				StateProvinceCode,
				"State"."Name" as "StateName",
				"Territory".TerritoryID,
				"Territory"."Name" as "TerritoryName",
				"State".CountryRegionCode,
				"Country"."Name" as "CountryName"
		FROM (
		[AdventureWorks2012].[Person].[StateProvince] as "State"
		left join 
		[Person].[CountryRegion] as "Country"
		on "State".CountryRegionCode = "Country".CountryRegionCode )
		left join 
		[Sales].[SalesTerritory] as "Territory"
		on "State".TerritoryID = "Territory".TerritoryID
	) as "CountryRegion"
	on "Address".StateProvinceID = "CountryRegion".StateProvinceID
) as "Person"
on "Customer".PersonID = "Person".BusinessEntityID
  