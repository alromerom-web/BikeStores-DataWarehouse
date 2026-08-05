USE BikeStoresDW;
GO

-- Script para generar y poblar automáticamente la dimensión DimDate
DECLARE @StartDate DATE = '2016-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        DateKey,
        FullDate,
        Year,
        Quarter,
        Month,
        MonthName,
        DayOfWeek,
        DayName
    )
    VALUES (
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO