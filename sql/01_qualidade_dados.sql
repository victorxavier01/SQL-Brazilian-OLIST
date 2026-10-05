-- 1.1 Contagem por tabelas
SELECT
    (SELECT COUNT(*) FROM customers)            AS customers,
    (SELECT COUNT(*) FROM products)             AS products,
    (SELECT COUNT(*) FROM orders)               AS orders,
    (SELECT COUNT(*) FROM orders_items)         AS orders_items,
    (SELECT COUNT(*) FROM orders_payments)      AS orders_payments,
    (SELECT COUNT(*) FROM orders_reviews)       AS orders_reviews,
    (SELECT COUNT(*) FROM sellers)              AS sellers,
    (SELECT COUNT(*) FROM geolocation)          AS geolocation,
    (SELECT COUNT(*) FROM category_translation) AS category_translation;

-- 1.2 Janela temporal
SELECT
	COUNT(DISTINCT o.order_id)    AS total_pedidos,
	COUNT(DISTINCT o.customer_id) AS total_clientes,
	MIN(o.order_purchase_timestamp) AS primeira_compra,
	MAX(o.order_purchase_timestamp) AS ultima_compra
FROM
	orders o
JOIN orders_items oi ON oi.order_id = o.order_id;

-- 2.1 Itens de pedidos nulos
SELECT
	COUNT(*) FILTER (WHERE order_item_id IS NULL)       AS null_order_item_id,
	COUNT(*) FILTER (WHERE product_id IS NULL)          AS null_product_id,
	COUNT(*) FILTER (WHERE seller_id IS NULL)           AS null_seller_id,
	COUNT(*) FILTER (WHERE shipping_limit_date IS NULL) AS null_shipping_limit_date,
	COUNT(*) FILTER (WHERE price IS NULL)               AS null_price,
	COUNT(*) FILTER (WHERE freight_value IS NULL)       AS null_freight
FROM
	orders_items;

-- 2.2 Pedidos com itens nulos
SELECT
	COUNT(*) FILTER (WHERE customer_id IS NULL)                   AS null_customer_id,
	COUNT(*) FILTER (WHERE order_status IS NULL)                  AS null_status,
	COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL)      AS null_purchase,
	COUNT(*) FILTER (WHERE order_approved_at IS NULL)             AS null_approved,
	COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL)  AS null_carrier,
	COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS null_delivered,
	COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS null_estimated
FROM
	orders;

-- 2.3 Avaliações nulas
SELECT
	COUNT(*) FILTER (WHERE order_id IS NULL)               AS null_order_id,
	COUNT(*) FILTER (WHERE review_score IS NULL)           AS null_score,
	COUNT(*) FILTER (WHERE review_comment_title IS NULL)   AS null_title,
	COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS null_message
FROM
	orders_reviews;

-- 2.4 Pagamentos
SELECT
	COUNT(*) FILTER (WHERE payment_type IS NULL)         AS null_type,
	COUNT(*) FILTER (WHERE payment_installments IS NULL) AS null_installments,
	COUNT(*) FILTER (WHERE payment_value IS NULL)        AS null_value
FROM
	orders_payments;

-- 3.1 Duplicatas mesmo endereço
SELECT
	COUNT(*)           AS pessoas_com_varios_enderecos,
	MAX(qtd_enderecos) AS max_enderecos_por_pessoa
FROM (
	SELECT customer_unique_id,
	       COUNT(DISTINCT customer_id) AS qtd_enderecos
	FROM customers
	GROUP BY customer_unique_id
	HAVING COUNT(DISTINCT customer_id) > 1
) t;

-- 3.2 Conferindo duplicatas
SELECT
	COUNT(*)                 AS linhas,
	COUNT(DISTINCT order_id) AS pedidos_distintos
FROM
	orders;