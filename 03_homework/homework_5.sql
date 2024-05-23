-- Cross Join
WITH customer_count AS (
    SELECT COUNT(*) AS num_customers
    FROM customer
),

vendor_product_sales AS (
    SELECT
        v.vendor_name,
        p.product_name,
        5 * cc.num_customers * cp.cost_to_customer_per_qty AS total_sales
    FROM 
        vendor_inventory vi
    JOIN 
        vendor v ON vi.vendor_id = v.vendor_id
    JOIN 
        product p ON vi.product_id = p.product_id
	JOIN
	    customer_purchases cp ON cp.vendor_id = vi.vendor_id
    CROSS JOIN
        customer_count cc
)
SELECT
    vendor_name,
    product_name,
    total_sales
FROM
    vendor_product_sales
GROUP BY
    vendor_name,
    product_name
	
-- INSERT
CREATE TABLE product_units AS
SELECT 
    product_id, 
    product_name, 
    product_size, 
    product_category_id, 
    product_qty_type,
    CURRENT_TIMESTAMP AS snapshot_timestamp
FROM 
    product
WHERE 
    product_qty_type = 'unit';

INSERT INTO product_units (product_id, product_name, product_size, product_category_id, product_qty_type, snapshot_timestamp)
VALUES 
    (8, 'Cherry Pie', '15''', 3, 'unit', CURRENT_TIMESTAMP);

SELECT 
    product_id, 
    product_name, 
    product_size, 
    product_category_id, 
    product_qty_type,
    snapshot_timestamp
FROM 
    product_units;
	
-- Delete
DELETE FROM product_units
WHERE 
    product_name = 'Cherry Pie' 
    AND snapshot_timestamp < (
        SELECT MAX(snapshot_timestamp) 
        FROM product_units 
        WHERE product_name = 'Cherry Pie'
    );

-- Updates

ALTER TABLE product_units
ADD current_quantity INT;
UPDATE product_units
SET current_quantity = COALESCE((
    SELECT MAX(quantity)
    FROM vendor_inventory
    WHERE vendor_inventory.product_id = product_units.product_id
), 0);

SELECT *
FROM product_units;

