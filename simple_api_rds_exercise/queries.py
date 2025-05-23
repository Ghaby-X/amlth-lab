# gets customers with the highest spendings
get_top_customers = """
    SELECT 
        customers.customer_id,
        customers.name,
        customers.email,
        SUM(order_items.quantity * order_items.unit_price) AS total_spent
    FROM 
        customers
    JOIN 
        orders ON customers.customer_id = orders.customer_id
    JOIN 
        order_items ON orders.order_id = order_items.order_id
    GROUP BY 
        customers.customer_id, customers.name, customers.email
    ORDER BY 
        total_spent DESC;
"""

# get all monthly sales
get_monthly_sales = """
    SELECT 
        YEAR(orders.order_date) as year, 
        MONTH(orders.order_date) as month, 
        SUM(order_items.quantity * order_items.unit_price) as total_price 
    FROM 
        orders 
    JOIN 
        order_items ON orders.order_id=order_items.order_id
    WHERE 
        orders.status IN ('Shipped', 'Delivered') 
    GROUP BY
        year, month
    ORDER BY
        year DESC, month DESC;
"""

# gets all products that have never been ordered
get_products_never_ordered = """
    SELECT 
        products.product_id,
        products.name,
        products.category,
        products.price
    FROM 
        products
    LEFT JOIN 
        order_items ON products.product_id = order_items.product_id
    WHERE 
        order_items.product_id IS NULL;
"""

# gets the average orders by country
get_avg_order_by_country ="""
    SELECT 
        customers.country,
        AVG(order_total) AS avg_order_value
    FROM (
        SELECT 
            orders.order_id,
            SUM(order_items.quantity * order_items.unit_price) AS order_total,
            orders.customer_id
        FROM 
            orders
        JOIN 
            order_items ON orders.order_id = order_items.order_id
        GROUP BY 
            orders.order_id, orders.customer_id
    ) AS order_values
    JOIN 
        customers ON order_values.customer_id = customers.customer_id
    GROUP BY 
        customers.country
    ORDER BY 
        avg_order_value DESC;
"""

# gets customers that have purchased at least one item
get_frequent_buyers = """
    SELECT 
        customers.customer_id,
        customers.name,
        customers.email,
        COUNT(orders.order_id) AS order_count
    FROM 
        customers
    JOIN 
        orders ON customers.customer_id = orders.customer_id
    GROUP BY 
        customers.customer_id, customers.name, customers.email
    HAVING 
        COUNT(orders.order_id) > 1
    ORDER BY 
        order_count DESC;
"""