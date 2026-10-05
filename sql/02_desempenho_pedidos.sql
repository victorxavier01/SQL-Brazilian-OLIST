-- 1. KPIs gerais
SELECT
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    COUNT(DISTINCT oi.order_item_id) AS itens_vendidos,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS receita_total,
    ROUND(SUM(oi.price), 2) AS receita_produto,
    ROUND(SUM(oi.freight_value), 2) AS receita_frete,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM orders o
INNER JOIN orders_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');

-- 2. Tendências mensais
SELECT
    DATE_TRUNC('month', o.orders_purchase_timestamp)    AS mes,
    COUNT(DISTINCT o.order_id)                          AS total_pedidos,
    COUNT(DISTINCT oi.order_item_id)                    AS itens_vendidos,
    ROUND(SUM(oi.price + oi.freight_value), 2)          AS receita_total
FROM orders o
INNER JOIN orders_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY 1
ORDER BY 1;

-- 3.1 Prazo de entrega
SELECT
    COUNT(*) AS total_pedidos,
    COUNT(*) FILTER (WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date) AS pedidos_atrasados,
    ROUND(100 * COUNT(*) FILTER (WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date) / COUNT(*), 2) AS pct,atrasados,
    ROUND(AVG(o.order_delivered_customer_date - o.order_estimated_delivery_date), 2) AS atraso_medio
FROM orders o
WHERE o.order_status = 'delivered';

-- 3.2 Prazo de entrega por categoria
WITH entregas AS (
    SELECT
        o.order_id,
        o.order_delivered_customer_date::date - o.order_estimated_delivery_date::date AS atraso_dias
    FROM orders o
    WHERE o.order_status = 'delivered'
)
SELECT
    p.product_category_name,
    COUNT(e.order_id)                                  AS pedidos,
    ROUND(AVG(e.atraso_dias), 1)                       AS atraso_medio,
    COUNT(e.order_id) FILTER (WHERE e.atraso_dias > 0) AS pedidos_atrasados
FROM entregas e
INNER JOIN orders_items oi ON e.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
GROUP BY 1
ORDER BY pedidos DESC
LIMIT 15;

-- 4. Categorias mais lucrativas
SELECT
    p.product_category_name,
    COUNT(DISTINCT o.order_id)                 AS total_pedidos,
    COUNT(oi.order_item_id)                    AS itens_vendidos,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS receita_total
FROM orders_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY 1
ORDER BY receita_total DESC
LIMIT 10;

-- 5. Produtos mais vendidos
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    COUNT(oi.order_item_id) AS itens_vendidos,
    ROUND(SUM(oi.price), 2) AS receita
FROM orders_items oi
INNER JOIN products p ON p.product_id = oi.product_id
INNER JOIN orders o ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY 1, 2
ORDER BY itens_vendidos DESC
LIMIT 10;