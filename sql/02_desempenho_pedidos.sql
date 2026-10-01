-- 1. KPIs
SELECT * FROM orders_items LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM customers LIMIT 5;

-- 1.1 Itens mais vendidos
SELECT 
    product_id,
    COUNT(DISTINCT order_id) AS total_pedidos,
    COUNT(order_item_id) AS total_vezes_comprado
FROM
    orders_items
GROUP BY 
    product_id
ORDER BY 
    total_vezes_comprado DESC;

-- 1.2 Melhores vendedores
SELECT
	seller_id,
	COUNT(DISTINCT order_id) AS total_vendas,
	COUNT(order_item_id) AS total_vezes_vendidas
FROM
	orders_items
GROUP BY
	seller_id
ORDER BY
	total_vezes_vendidas DESC;

