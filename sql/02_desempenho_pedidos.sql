-- 1. KPIs gerais
SELECT
    COUNT(DISTINCT o.order_id) as total_pedidos,
    COUNT(DISTINCT oi.order_item_id) as itens_vendidos,
    ROUND(SUM(oi.price + oi.freight_value), 2) as receita_total,
    ROUND(SUM(oi.price), 2) as receita_produto,
    ROUND(SUM(oi.freight_value), 2) as receita_frete,
    ROUND(SUM(oi.price + oi.freight_value) / COUNT(DISTINCT o.order_id), 2) as ticket_medio
FROM orders o
INNER JOIN orders_items oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable');
