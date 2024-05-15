SELECT *
FROM customer
ORDER BY customer_last_name, customer_first_name
LIMIT 10;

SELECT *
FROM customer_purchases
WHERE product_id IN (4, 9);

SELECT *, quantity * cost_to_customer_per_qty AS price
FROM customer_purchases
WHERE vendor_id >= 8 AND vendor_id <= 10;

SELECT 
    product_id,
    product_name,
    CASE 
        WHEN product_qty_type = 'unit' THEN 'unit'
        ELSE 'bulk'
    END AS prod_qty_type_condensed,
    CASE 
        WHEN LOWER(product_name) LIKE '%pepper%' THEN 1
        ELSE 0
    END AS pepper_flag
FROM 
    product;

SELECT 
    vendor.vendor_id,
    vendor.vendor_name,
    vendor.vendor_type,
    vendor.vendor_owner_first_name,
	vendor.vendor_owner_last_name,
	vendor_booth_assignments.vendor_id,
    vendor_booth_assignments.booth_number,
    vendor_booth_assignments.market_date
FROM 
    vendor
INNER JOIN 
    vendor_booth_assignments ON vendor.vendor_id = vendor_booth_assignments.vendor_id
ORDER BY 
    vendor.vendor_name, vendor_booth_assignments.market_date;

