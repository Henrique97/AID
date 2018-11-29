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
    ProductSK int(11),
    ProductID int(11),
    Name varchar(50),
    ProductSubcategoryName varchar(50),
    ProductCategoryName varchar(50),
    Version int,
    DateFrom DATETIME,
    DateTo DATETIME,
    PRIMARY KEY (ProductSK)
);

-- salesorderheader
CREATE TABLE dim_time (
    OrderDate timestamp NOT NULL,
    `Day` int,
    MonthID int,
    MonthName varchar(255),
    `Year` int,
    PRIMARY KEY (OrderDate)
);

-- salesorderdetail & salesorderheader
CREATE TABLE fact_order (
    SalesOrderID int(11) NOT NULL,
    SalesOrderDetailID int(11) NOT NULL,
    TerritoryID int(11) NOT NULL,
    ProductSK int(11) NOT NULL,
    OrderDate timestamp NOT NULL,
    LineTotal double NOT NULL,
    OrderQty smallint(6) NOT NULL,
    PRIMARY KEY (SalesOrderDetailID, SalesOrderID),
    FOREIGN KEY (TerritoryID) REFERENCES dim_territory (TerritoryID),
    FOREIGN KEY (ProductSK) REFERENCES dim_product (ProductSK),
    FOREIGN KEY (OrderDate) REFERENCES dim_time (OrderDate)
);
