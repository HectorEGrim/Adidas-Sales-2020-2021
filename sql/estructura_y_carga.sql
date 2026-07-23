-- Creacion del  Data Base  AdidasVentas
CREATE DATABASE AdidasVentas;

--Uso de la Data Base
USE AdidasVentas

/*Crear tablas*/

-- Tabla de dimension: Categorias
CREATE TABLE dbo.DimCategory
(
    CategoryID INT NOT NULL PRIMARY KEY,
    Category NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Familias
CREATE TABLE dbo.DimFamily
(
    FamilyID INT NOT NULL PRIMARY KEY,
    Family NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Generos
CREATE TABLE dbo.DimGender
(
    GenderID INT NOT NULL PRIMARY KEY,
    Gender NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Regiones
CREATE TABLE dbo.DimRegion
(
    RegionID INT NOT NULL PRIMARY KEY,
    Region NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Estados
CREATE TABLE dbo.DimState
(
    StateID INT NOT NULL PRIMARY KEY,
    State NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Ciudades
CREATE TABLE dbo.DimCity
(
    CityID INT NOT NULL PRIMARY KEY,
    City NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Colores
CREATE TABLE dbo.DimColor
(
    ColorID INT NOT NULL PRIMARY KEY,
    PrimaryColor NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Tipo de producto
CREATE TABLE dbo.DimProductType
(
    ProductTypeID INT NOT NULL PRIMARY KEY,
    Silhouette NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Tipo de venta
CREATE TABLE dbo.DimSalesMethod
(
    SalesMethodID INT NOT NULL PRIMARY KEY,
    SalesMethod NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Vendedor / Retailer
CREATE TABLE dbo.DimRetailer
(
    RetailerID INT NOT NULL PRIMARY KEY,
    Retailer NVARCHAR(100) NOT NULL
);

-- Tabla de dimension: Productos
CREATE TABLE dbo.DimProduct
(
    ProductID INT NOT NULL PRIMARY KEY,
    Product NVARCHAR(150) NOT NULL
);


/* Creacion de Tabla de hechos: Ventas*/

CREATE TABLE dbo.FactSales
(
    SalesID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,

    RetailerID INT NOT NULL,
    InvoiceDate DATE NOT NULL,
    RegionID INT NOT NULL,
    StateID INT NOT NULL,
    CityID INT NOT NULL,
    ProductID INT NOT NULL,
    FamilyID INT NOT NULL,
    GenderID INT NOT NULL,
    CategoryID INT NOT NULL,
    ProductTypeID INT NOT NULL,
    ColorID INT NOT NULL,

    PricePerUnit DECIMAL(10,2) NOT NULL,
    UnitsSold INT NOT NULL,
    OperatingMargin DECIMAL(10,2) NOT NULL,
    SalesMethodID INT NOT NULL
);

--LLenar las columnas importando los datos desde los archivos csv
BULK INSERT dbo.DimCategory
FROM 'C:\adidas\CATEGORIAS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimFamily
FROM 'C:\adidas\FAMILIAS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimGender
FROM 'C:\adidas\GENEROS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimRegion
FROM 'C:\adidas\REGIONES.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimState
FROM 'C:\adidas\ESTADOS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimCity
FROM 'C:\adidas\CIUDADES.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimColor
FROM 'C:\adidas\COLORES.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimProductType
FROM 'C:\adidas\TIPO DE PRODUCTO.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);


BULK INSERT dbo.DimSalesMethod
FROM 'C:\adidas\TIPO DE VENTA.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

-- 10. DimRetailer usando tabla temporal

CREATE TABLE #StageRetailer
(
    Retailer NVARCHAR(100),
    RetailerID INT
);

BULK INSERT #StageRetailer
FROM 'C:\adidas\VENDEDOR.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

INSERT INTO dbo.DimRetailer (RetailerID, Retailer)
SELECT RetailerID, Retailer
FROM #StageRetailer;

DROP TABLE #StageRetailer;


-- 11. DimProduct usando tabla temporal
-- DimProduct
CREATE TABLE #StageProduct
(
    Product NVARCHAR(150),
    ProductID INT
);

BULK INSERT #StageProduct
FROM 'C:\adidas\PRODUCTOS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

INSERT INTO dbo.DimProduct (ProductID, Product)
SELECT ProductID, Product
FROM #StageProduct;

DROP TABLE #StageProduct;



-- Carga de datos: FactSales desde VENTAS.csv


CREATE TABLE #StageSales
(
    RetailerID INT,
    InvoiceDateText NVARCHAR(20),
    RegionID INT,
    StateID INT,
    CityID INT,
    ProductID INT,
    FamilyID INT,
    GenderID INT,
    CategoryID INT,
    ProductTypeID INT,
    ColorID INT,
    PricePerUnit DECIMAL(10,2),
    UnitsSold INT,
    OperatingMargin DECIMAL(10,2),
    SalesMethodID INT
);

BULK INSERT #StageSales
FROM 'C:\adidas\VENTAS.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001'
);

INSERT INTO dbo.FactSales
(
    RetailerID,
    InvoiceDate,
    RegionID,
    StateID,
    CityID,
    ProductID,
    FamilyID,
    GenderID,
    CategoryID,
    ProductTypeID,
    ColorID,
    PricePerUnit,
    UnitsSold,
    OperatingMargin,
    SalesMethodID
)
SELECT
    RetailerID,
    CONVERT(DATE, InvoiceDateText, 103),
    RegionID,
    StateID,
    CityID,
    ProductID,
    FamilyID,
    GenderID,
    CategoryID,
    ProductTypeID,
    ColorID,
    PricePerUnit,
    UnitsSold,
    OperatingMargin,
    SalesMethodID
FROM #StageSales;

DROP TABLE #StageSales;

SELECT COUNT(*) AS Ventas
FROM dbo.FactSales;

-- Relaciones entre FactSales y dimensiones (Foreign Keys)

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimRetailer
FOREIGN KEY (RetailerID) REFERENCES dbo.DimRetailer(RetailerID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimRegion
FOREIGN KEY (RegionID) REFERENCES dbo.DimRegion(RegionID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimState
FOREIGN KEY (StateID) REFERENCES dbo.DimState(StateID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimCity
FOREIGN KEY (CityID) REFERENCES dbo.DimCity(CityID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimProduct
FOREIGN KEY (ProductID) REFERENCES dbo.DimProduct(ProductID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimFamily
FOREIGN KEY (FamilyID) REFERENCES dbo.DimFamily(FamilyID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimGender
FOREIGN KEY (GenderID) REFERENCES dbo.DimGender(GenderID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimCategory
FOREIGN KEY (CategoryID) REFERENCES dbo.DimCategory(CategoryID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimProductType
FOREIGN KEY (ProductTypeID) REFERENCES dbo.DimProductType(ProductTypeID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimColor
FOREIGN KEY (ColorID) REFERENCES dbo.DimColor(ColorID);

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_FactSales_DimSalesMethod
FOREIGN KEY (SalesMethodID) REFERENCES dbo.DimSalesMethod(SalesMethodID);

