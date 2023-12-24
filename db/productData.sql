CREATE TABLE Market (
    MarketId INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL
);

INSERT INTO Market (MarketId, Name) VALUES
(1, 'Market A'),
(2, 'Market B'),
(3, 'Market C');

-- Crear tabla Product
CREATE TABLE Product (
    ProductId INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Sku VARCHAR(20) UNIQUE NOT NULL,
    Ean VARCHAR(20) NOT NULL,
    MarketId INT,
    FOREIGN KEY (MarketId) REFERENCES Market(MarketId)
);

INSERT INTO Product (ProductId, Name, Sku, Ean, MarketId) VALUES
(1, 'Product 1', 'SKU001', 'EAN001', 1),
(2, 'Product 2', 'SKU002', 'EAN002', 1),
(3, 'Product 3', 'SKU003', 'EAN003', 2),
(4, 'Product 1', 'SKU004', 'EAN001', 3),
(5, 'Product 2', 'SKU005', 'EAN002', 3);

-- Crear tabla Price
CREATE TABLE Price (
    PriceId INT PRIMARY KEY,
    ProductId INT,
    normal_price DECIMAL(10, 2),
    discount_price DECIMAL(10, 2),
    active INT,
    create_date DATE,
    FOREIGN KEY (ProductId) REFERENCES Product(ProductId)
);

INSERT INTO Price (PriceId, ProductId, normal_price, discount_price, active, create_date) VALUES
(1, 1, 20.00, 15.00, 1, '2023-01-01'),
(2, 1, 18.00, 12.00, 1, '2023-02-01'),
(3, 2, 25.00, 20.00, 1, '2023-01-15'),
(4, 2, 22.00, 18.00, 1, '2023-02-15'),
(5, 3, 30.00, 25.00, 0, '2023-01-01'),
(6, 3, 28.00, 22.00, 1, '2023-02-01'),
(7, 4, 15.00, 10.00, 1, '2023-01-01'),
(8, 5, 22.00, 18.00, 1, '2023-01-15'),
(9, 5, 20.00, 15.00, 1, '2023-02-01');

WITH RankedPrices AS (
    SELECT
        pr.ProductId,
        pr.normal_price,
        pr.discount_price,
        pr.active,
        pr.create_date,
        ROW_NUMBER() OVER (PARTITION BY pr.ProductId ORDER BY pr.create_date DESC, pr.discount_price ASC) AS rn
    FROM
        Price pr
    WHERE
        pr.active = 1
)
SELECT
    p.Name AS ProductName,
    p.Ean,
    p.Sku,
    m.Name AS Market,
    rp.normal_price AS LastLowestPrice,
    rp.discount_price AS LastLowestDiscountPrice
FROM
    Product p
JOIN
    Market m ON p.MarketId = m.MarketId
JOIN
    RankedPrices rp ON p.ProductId = rp.ProductId AND rp.rn = 1;