
SELECT 
    u.user_id,
    u.country,
    (SELECT p.product_name FROM products p WHERE p.product_id = r.product_id) AS hated_product_name,
    (SELECT SUM(pur.total_amount) FROM purchases pur WHERE pur.user_id = u.user_id) AS total_lifetime_spent
FROM 
    users u, 
    reviews r
WHERE 
    u.user_id = r.user_id
    AND r.rating <= 2
    AND r.product_id IN (
        SELECT product_id 
        FROM products 
        WHERE product_name LIKE '%Pro%' OR product_name LIKE '%Max%'
    )
    AND u.user_id IN (
        SELECT user_id 
        FROM purchases 
        WHERE product_id = r.product_id
    )
    AND 60000 < (
        SELECT SUM(i.dwell_time_ms) 
        FROM interactions i 
        WHERE i.user_id = u.user_id 
          AND i.product_id = r.product_id 
          AND i.interaction_type = 'view'
    );