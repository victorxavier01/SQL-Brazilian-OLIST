-- SCHEMAS

-- 1. LIMPEZA
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS orders_items;


-- 2. Tabela de Clientes
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2)
);

-- Índice Clientes e Estado
CREATE INDEX idx_customers_unique_id ON customers(customer_unique_id);
CREATE INDEX idx_customers_state ON customers(customer_state);

-- 3. Tabela produtos
CREATE TABLE products (
	product_id VARCHAR(50) PRIMARY KEY,
	product_category_name VARCHAR(50) NOT NULL,
	product_name_lenght INT,
	product_description_lenght INT,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);

-- Índice produtos
CREATE INDEX idx_products_category ON products(product_category_name);

-- 4. Tabela pedidos
CREATE TABLE orders (
	order_id VARCHAR(50) PRIMARY KEY,
	customer_id VARCHAR(50) NOT NULL,
	order_status VARCHAR(20),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);

-- Índice Pedidos
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_purchase_date ON orders(order_purchase_timestamp);

-- 5. Tabela itens pedidos
CREATE TABLE orders_items (
	order_id VARCHAR(50),
	order_item_id int NOT NULL,
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date TIMESTAMP,
	price DECIMAL(10,2),
	freight_value DECIMAL(10,2),
	PRIMARY KEY(order_id, order_item_id),
	FOREIGN KEY(product_id) REFERENCES products(product_id),
	FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

-- Índice itens pedidos
CREATE INDEX idx_order_item_seller_id ON orders_items(seller_id);
CREATE INDEX idx_order_item_product_id ON orders_items(product_id);
