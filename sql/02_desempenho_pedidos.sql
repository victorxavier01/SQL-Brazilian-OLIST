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

