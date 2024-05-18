-- Coalesce

SELECT * 
FROM product
WHERE product_size IS NULL OR product_qty_type IS NULL;

SELECT 
  product_name || ', ' || 
  COALESCE(product_size, '') || ' (' || 
  COALESCE(product_qty_type, 'unit') || ')' 
  AS product_details
FROM 
  product;

-- Windowed Functions 
SELECT 
  customer_id, market_date, transaction_time, quantity,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date, transaction_time) AS visit_number
FROM 
  customer_purchases;

SELECT 
  customer_id, market_date, transaction_time, quantity,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC, transaction_time DESC) AS reverse_visit_number
FROM 
  customer_purchases;

WITH recent_visits AS (
    SELECT
        customer_id, market_date, transaction_time,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY market_date DESC, transaction_time DESC) AS recent_visit_number
    FROM
        customer_purchases
)
SELECT
    customer_id, market_date, transaction_time
FROM
    recent_visits
WHERE
    recent_visit_number = 1;

	
SELECT 
    customer_id, product_id, market_date, transaction_time, quantity,
    COUNT(*) OVER (PARTITION BY customer_id, product_id) AS purchase_count
FROM 
    customer_purchases;


--String manipulations
	
SELECT
    product_name,
    CASE
        WHEN INSTR(product_name, '-') > 0 THEN TRIM(SUBSTR(product_name, INSTR(product_name, '-') + 1))
        ELSE NULL
    END AS description
FROM
    product;

-- Union
WITH SalesByDate AS (
    SELECT
        market_date,
        SUM(cost_to_customer_per_qty * quantity) AS total_sales
    FROM
        customer_purchases
    GROUP BY
        market_date
),
RankedSalesByDate AS (
    SELECT
        market_date,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS sales_rank_desc,
        RANK() OVER (ORDER BY total_sales ASC) AS sales_rank_asc
    FROM
        SalesByDate
)

SELECT
    market_date,
    total_sales
FROM
    RankedSalesByDate
WHERE
    sales_rank_desc = 1

UNION

SELECT
    market_date,
    total_sales
FROM
    RankedSalesByDate
WHERE
    sales_rank_asc = 1;


