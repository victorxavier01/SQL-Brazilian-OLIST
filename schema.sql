-- 1. LIMPEZA (filhos primeiro, depois os pais)
DROP TABLE IF EXISTS orders_items;
DROP TABLE IF EXISTS orders_payments;
DROP TABLE IF EXISTS orders_reviews;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS category_translation;
DROP TABLE IF EXISTS geolocation;


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
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
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
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id)
);

-- Índice Pedidos
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_purchase_date ON orders(order_purchase_timestamp);

-- 5. Tabela vendedores
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(60),
    seller_state VARCHAR(2)
);

-- Índice vendedores
CREATE INDEX idx_seller_city ON sellers(seller_city);
CREATE INDEX idx_seller_state ON sellers(seller_state);

-- 6. Tabela itens pedidos
CREATE TABLE orders_items (
    order_id VARCHAR(50),
    order_item_id INT NOT NULL,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY(order_id, order_item_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(seller_id) REFERENCES sellers(seller_id)
);

-- Índice itens pedidos
CREATE INDEX idx_order_item_seller_id ON orders_items(seller_id);
CREATE INDEX idx_order_item_product_id ON orders_items(product_id);

-- 7. Tabela pagamentos
CREATE TABLE orders_payments (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10,2),
    PRIMARY KEY(order_id, payment_sequential),
    FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

-- Índice pagamentos
CREATE INDEX idx_payments_installments ON orders_payments(payment_installments);
CREATE INDEX idx_payments_type ON orders_payments(payment_type);

-- 8. Tabela reviews
CREATE TABLE orders_reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(40),
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY(order_id) REFERENCES orders(order_id)
);

-- Índice reviews
CREATE INDEX idx_review_score ON orders_reviews(review_score);
CREATE INDEX idx_reviews_order_id ON orders_reviews(order_id);

-- 9. Tabela geolocalização
CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat DECIMAL(10,6),
    geolocation_lng DECIMAL(10,6),
    geolocation_city VARCHAR(60),
    geolocation_state VARCHAR(2)
);

-- Índice geolocalização
CREATE INDEX idx_geolocation_city ON geolocation(geolocation_city);
CREATE INDEX idx_geolocation_state ON geolocation(geolocation_state);

-- 10. Tabela de tradução de categorias
CREATE TABLE category_translation (
    product_category_name VARCHAR(50) PRIMARY KEY,
    product_category_name_translation VARCHAR(100) NOT NULL
);
