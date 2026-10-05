-- 1. Tamanho da base de dados
SELECT
	COUNT(DISTINCT o.order_id) AS total_pedidos,
	COUNT(DISTINCT o.customer_id ) AS total_clientes,
	MIN(o.order_purchase_timestamp) AS primeira_compra,
	MAX(o.order_purchase_timestamp ) AS ultima_compra
FROM
	orders_items oi
JOIN orders o ON oi.order_id = o.order_id;

-- 2. Valores vazios
SELECT
	COUNT(*) FILTER (WHERE order_item_id IS null) AS null_order_item_id,
	COUNT(*) FILTER (WHERE product_id IS null) AS null_product_id,
	COUNT(*) FILTER (WHERE seller_id IS null) AS null_seller_id,
	COUNT(*) FILTER (WHERE shipping_limit_date IS null) AS null_shopping_date,
	COUNT(*) FILTER (WHERE price IS null) AS null_price,
	COUNT(*) FILTER (WHERE freight_value IS null) AS null_freight
FROM
	orders_items;

-- 3. Buscando anomalias

SELECT
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
FROM 
	orders_items
WHERE order_id IS NULL OR price < 0 OR freight_value < 0;