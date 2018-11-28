DROP DATABASE IF EXISTS adventureworks_dw;
CREATE DATABASE adventureworks_dw;

USE adventureworks_dw;

-- salesterritory
CREATE TABLE dim_territory (
    TerritoryID int(11) NOT NULL,
    Name varchar(50) NOT NULL,
    CountryRegionCode varchar(3) NOT NULL,
    `Group` varchar(50) NOT NULL,
    PRIMARY KEY (TerritoryID)
);

-- product, productsubcategory & productcategory
-- Slowly changing dimension!
CREATE TABLE dim_product (
    ProductID int(11) NOT NULL,
    Name varchar(50) NOT NULL,
    ProductSubcategoryName varchar(50) NOT NULL,
    ProductCategoryName varchar(50) NOT NULL,
    PRIMARY KEY (ProductID)
);

-- salesorderheader or purchaseorderheader?
CREATE TABLE dim_time (
    OrderDate timestamp NOT NULL,
    `Day` int,
    MonthID int,
    MonthName varchar(255),
    `Year` int,
    PRIMARY KEY (OrderDate)
);

-- salesorderdetail or purchaseorderdetail?
-- Also the corresponding header
CREATE TABLE fact_order (
    SalesOrderID int(11) NOT NULL,
    SalesOrderDetailID int(11) NOT NULL,
    TerritoryID int(11) NOT NULL,
    ProductID int(11) NOT NULL,
    OrderDate timestamp NOT NULL,
    LineTotal double NOT NULL,
    OrderQty smallint(6) NOT NULL,
    PRIMARY KEY (SalesOrderDetailID, SalesOrderID),
    FOREIGN KEY (TerritoryID) REFERENCES dim_territory (TerritoryID),
    FOREIGN KEY (ProductID) REFERENCES dim_product (ProductID),
    FOREIGN KEY (OrderDate) REFERENCES dim_time (OrderDate)
);
