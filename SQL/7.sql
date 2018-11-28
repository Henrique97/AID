Select sum(OrderQty) as TotalQ, CountryRegionCode, ProductCategoryName
From fact_order natural join (Select TerritoryID, CountryRegionCode From dim_territory) as dim_Region natural join dim_product
Group by CountryRegionCode, ProductCategoryName with Rollup;