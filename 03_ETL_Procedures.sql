USE BikeStoresDW;
GO

-- 1. ETL para Cargar Dimensión Cliente
CREATE OR ALTER PROCEDURE sp_CargarDimCustomer AS
BEGIN
    MERGE DimCustomer AS Target
    USING BikeStores.sales.customers AS Source
    ON (Target.CustomerId = Source.customer_id)
    WHEN MATCHED THEN
        UPDATE SET 
            Target.FirstName = Source.first_name,
            Target.LastName  = Source.last_name,
            Target.Email     = Source.email,
            Target.City      = Source.city,
            Target.State     = Source.state,
            Target.ZipCode   = Source.zip_code
    WHEN NOT MATCHED THEN
        INSERT (CustomerId, FirstName, LastName, Email, City, State, ZipCode)
        VALUES (Source.customer_id, Source.first_name, Source.last_name, Source.email, Source.city, Source.state, Source.zip_code);
END;
GO

-- 2. ETL para Cargar Tabla de Hechos (FactOrders)
CREATE OR ALTER PROCEDURE sp_CargarFactOrders AS
BEGIN
    INSERT INTO FactOrders (
        OrderId, OrderItemId, CustomerKey, ProductKey, 
        StoreKey, StaffKey, OrderDateKey, Quantity, ListPrice, Discount
    )
    SELECT 
        o.order_id,
        oi.item_id,
        c.CustomerKey,
        p.ProductKey,
        s.StoreKey,
        st.StaffKey,
        CAST(CONVERT(VARCHAR(8), o.order_date, 112) AS INT) AS OrderDateKey,
        oi.quantity,
        oi.list_price,
        oi.discount
    FROM BikeStores.sales.orders o
    INNER JOIN BikeStores.sales.order_items oi ON o.order_id = oi.order_id
    LEFT JOIN DimCustomer c ON o.customer_id = c.CustomerId
    LEFT JOIN DimProduct p ON oi.product_id = p.ProductId
    LEFT JOIN DimStore s ON o.store_id = s.StoreId
    LEFT JOIN DimStaff st ON o.staff_id = st.StaffId;
END;
GO