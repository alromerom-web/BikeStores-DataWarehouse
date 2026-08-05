-- ===================================================
-- PROYECTO: BikeStores Data Warehouse
-- DESCRIPCIÓN: Script para creación de esquema multidimensional (Estrella)
-- ===================================================

-- Crear base de datos para el Data Warehouse
CREATE DATABASE BikeStoresDW;
GO

USE BikeStoresDW;
GO

-- 1. TABLAS DIMENSIONALES (Desnormalizadas)

-- Dimensión Cliente
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY, -- Clave Subrogada (Surrogate Key)
    CustomerId INT NOT NULL,                  -- Clave de Negocio (Business Key)
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Email VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(25),
    ZipCode VARCHAR(5)
);

-- Dimensión Producto
CREATE TABLE DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductId INT NOT NULL,
    ProductName VARCHAR(255),
    BrandName VARCHAR(255),
    CategoryName VARCHAR(255),
    ModelYear SMALLINT,
    ListPrice DECIMAL(10,2)
);

-- Dimensión Tienda / Sucursal
CREATE TABLE DimStore (
    StoreKey INT IDENTITY(1,1) PRIMARY KEY,
    StoreId INT NOT NULL,
    StoreName VARCHAR(255),
    City VARCHAR(50),
    State VARCHAR(25)
);

-- Dimensión Empleado / Personal
CREATE TABLE DimStaff (
    StaffKey INT IDENTITY(1,1) PRIMARY KEY,
    StaffId INT NOT NULL,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    Active TINYINT
);

-- Dimensión Tiempo / Fecha
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY, -- Formato YYYYMMDD
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName VARCHAR(20) NOT NULL
);

-- 2. TABLA DE HECHOS (Fact Table)

CREATE TABLE FactOrders (
    FactOrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderId INT NOT NULL,
    OrderItemId INT NOT NULL,
    
    -- Claves Foráneas referenciando a las Dimensiones
    CustomerKey INT FOREIGN KEY REFERENCES DimCustomer(CustomerKey),
    ProductKey INT FOREIGN KEY REFERENCES DimProduct(ProductKey),
    StoreKey INT FOREIGN KEY REFERENCES DimStore(StoreKey),
    StaffKey INT FOREIGN KEY REFERENCES DimStaff(StaffKey),
    OrderDateKey INT FOREIGN KEY REFERENCES DimDate(DateKey),
    
    -- Métricas / Hechos de Negocio
    Quantity INT NOT NULL,
    ListPrice DECIMAL(10,2) NOT NULL,
    Discount DECIMAL(4,2) NOT NULL,
    GrossAmount AS (Quantity * ListPrice),
    NetAmount AS (Quantity * ListPrice * (1 - Discount))
);
GO