-- 1.¿Cual es la facturacion total estimada?
SELECT
    FORMAT(SUM(PricePerUnit * UnitsSold), 'C0', 'es-AR') AS FacturacionTotal
FROM dbo.FactSales;

-- 2.¿Cuantas unidades se vendieron en total?

SELECT
    SUM(UnitsSold) AS UnidadesVendidas
FROM dbo.FactSales;

-- 3.¿Que categoria genero mayor facturacion?

SELECT
    dc.Category,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales fs
INNER JOIN dbo.DimCategory dc
    ON fs.CategoryID = dc.CategoryID
GROUP BY dc.Category
ORDER BY SUM(fs.PricePerUnit * fs.UnitsSold) DESC;

-- 4.¿Que retailer genero la mayor facturacion?

SELECT
    dr.Retailer AS Retailer,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimRetailer AS dr
    ON fs.RetailerID = dr.RetailerID
GROUP BY dr.Retailer
ORDER BY SUM(fs.PricePerUnit * fs.UnitsSold) DESC;

-- 5.¿Que region genero mayor facturacion?

SELECT
    dr.Region AS Region,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimRegion AS dr
    ON fs.RegionID = dr.RegionID
GROUP BY dr.Region
ORDER BY SUM(fs.PricePerUnit * fs.UnitsSold) DESC;

-- 6.¿Cuales fueron los 10 estados con mayor facturacion?

SELECT TOP 10
    ds.State AS Estado,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimState AS ds
    ON fs.StateID = ds.StateID
GROUP BY ds.State
ORDER BY SUM(fs.PricePerUnit * fs.UnitsSold) DESC;

-- 7.¿Cuales fueron los 10 productos mas vendidos por unidades?

SELECT TOP 10
    dp.Product AS Producto,
    SUM(fs.UnitsSold) AS UnidadesVendidas
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimProduct AS dp
    ON fs.ProductID = dp.ProductID
GROUP BY dp.Product
ORDER BY SUM(fs.UnitsSold) DESC;

-- 8.¿Que metodo de venta genero mayor facturacion?

SELECT
    dsm.SalesMethod AS MetodoVenta,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimSalesMethod AS dsm
    ON fs.SalesMethodID = dsm.SalesMethodID
GROUP BY dsm.SalesMethod
ORDER BY SUM(fs.PricePerUnit * fs.UnitsSold) DESC;

-- 9.¿Como evoluciono la facturación por mes?

SELECT
    YEAR(fs.InvoiceDate) AS Anio,
    MONTH(fs.InvoiceDate) AS Mes,
    FORMAT(SUM(fs.PricePerUnit * fs.UnitsSold), 'C0', 'es-AR') AS Facturacion
FROM dbo.FactSales AS fs
GROUP BY
    YEAR(fs.InvoiceDate),
    MONTH(fs.InvoiceDate)
ORDER BY
    Anio,
    Mes;

 -- 10.¿Cual fue el margen operativo promedio por categoria?

SELECT
    dc.Category AS Categoria,
    FORMAT(AVG(fs.OperatingMargin) / 100, 'P2', 'es-AR') AS MargenOperativoPromedio
FROM dbo.FactSales AS fs
INNER JOIN dbo.DimCategory AS dc
    ON fs.CategoryID = dc.CategoryID
GROUP BY dc.Category
ORDER BY AVG(fs.OperatingMargin) DESC;