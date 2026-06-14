-- ========================================
-- 电商购物平台数据库表结构
-- 数据库类型: MySQL / H2 / SQLite
-- ========================================

-- 1. 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密存储)',
    nickname VARCHAR(100) COMMENT '昵称',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    avatar VARCHAR(255) COMMENT '头像URL',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
);

-- 2. 商品分类表
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '分类名称',
    parent_id BIGINT DEFAULT 0 COMMENT '父级分类ID',
    sort INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-禁用 1-正常',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 3. 商品表
CREATE TABLE IF NOT EXISTS products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL COMMENT '商品名称',
    category_id BIGINT COMMENT '分类ID',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    original_price DECIMAL(10,2) COMMENT '原价',
    stock INT DEFAULT 0 COMMENT '库存',
    sales INT DEFAULT 0 COMMENT '销量',
    image VARCHAR(500) COMMENT '商品图片',
    description TEXT COMMENT '商品描述',
    status TINYINT DEFAULT 1 COMMENT '状态: 0-下架 1-上架',
    is_hot TINYINT DEFAULT 0 COMMENT '是否热门',
    is_new TINYINT DEFAULT 0 COMMENT '是否新品',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. 购物车表
CREATE TABLE IF NOT EXISTS cart (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    quantity INT NOT NULL DEFAULT 1 COMMENT '数量',
    selected TINYINT DEFAULT 1 COMMENT '是否选中: 0-未选 1-选中',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. 收货地址表
CREATE TABLE IF NOT EXISTS addresses (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    receiver_name VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    province VARCHAR(50) COMMENT '省份',
    city VARCHAR(50) COMMENT '城市',
    district VARCHAR(50) COMMENT '区县',
    detail_address VARCHAR(255) NOT NULL COMMENT '详细地址',
    is_default TINYINT DEFAULT 0 COMMENT '是否默认: 0-否 1-是',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 6. 订单主表
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    discount_amount DECIMAL(10,2) DEFAULT 0 COMMENT '优惠金额',
    pay_amount DECIMAL(10,2) NOT NULL COMMENT '实付金额',
    status VARCHAR(20) NOT NULL COMMENT '订单状态: pending-待付款 paid-已付款 shipped-已发货 completed-已完成 cancelled-已取消',
    
    -- 收货信息
    receiver_name VARCHAR(50) NOT NULL COMMENT '收货人',
    receiver_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    receiver_address VARCHAR(255) NOT NULL COMMENT '收货地址',
    
    -- 支付信息
    pay_time DATETIME COMMENT '支付时间',
    pay_type VARCHAR(20) COMMENT '支付方式: alipay-支付宝 wechat-微信 bank-银行卡',
    
    -- 物流信息
    express_no VARCHAR(50) COMMENT '快递单号',
    express_company VARCHAR(50) COMMENT '快递公司',
    ship_time DATETIME COMMENT '发货时间',
    
    remark VARCHAR(500) COMMENT '订单备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 7. 订单明细表
CREATE TABLE IF NOT EXISTS order_items (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL COMMENT '订单ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    product_name VARCHAR(200) NOT NULL COMMENT '商品名称(快照)',
    product_image VARCHAR(500) COMMENT '商品图片(快照)',
    product_price DECIMAL(10,2) NOT NULL COMMENT '商品单价(快照)',
    quantity INT NOT NULL COMMENT '购买数量',
    subtotal DECIMAL(10,2) NOT NULL COMMENT '小计金额',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 8. 商品收藏表
CREATE TABLE IF NOT EXISTS favorites (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    product_id BIGINT NOT NULL COMMENT '商品ID',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_product (user_id, product_id)
);

-- ========================================
-- 初始化数据
-- ========================================

-- 插入测试用户 (密码: 123456, 使用BCrypt加密)
INSERT INTO users (username, password, nickname, email, phone) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '管理员', 'admin@example.com', '13800138000'),
('user001', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5E', '测试用户', 'user@example.com', '13900139000');

-- 插入商品分类
INSERT INTO categories (name, parent_id, sort) VALUES
('手机', 0, 1),
('电脑', 0, 2),
('耳机', 0, 3),
('平板', 0, 4),
('配件', 0, 5);

-- 插入商品
INSERT INTO products (name, category_id, price, original_price, stock, sales, description, is_hot, is_new) VALUES
('iPhone 15 Pro', 1, 7999.00, 8999.00, 100, 520, '苹果最新款手机，A17 Pro芯片，钛金属设计', 1, 0),
('iPhone 15', 1, 5999.00, 6999.00, 150, 380, '苹果新一代智能手机', 0, 1),
('MacBook Pro 14', 2, 14999.00, 16999.00, 50, 120, 'M3 Pro芯片，专业级笔记本电脑', 1, 0),
('MacBook Air', 2, 8999.00, 9999.00, 80, 200, '轻薄便携笔记本', 0, 1),
('AirPods Pro 2', 3, 1899.00, 2199.00, 200, 800, '主动降噪，空间音频', 1, 0),
('AirPods 3', 3, 1399.00, 1599.00, 180, 450, '全新设计，MagSafe充电', 0, 1),
('iPad Pro 12.9', 4, 8999.00, 9999.00, 80, 150, 'M2芯片，Liquid Retina XDR显示屏', 1, 0),
('iPad Air', 4, 4599.00, 5299.00, 100, 220, '轻薄平板，学习娱乐两相宜', 0, 1),
('小米14 Ultra', 1, 5999.00, 6999.00, 150, 300, '徕卡影像旗舰', 1, 1),
('华为Mate 60 Pro', 1, 6999.00, 7999.00, 100, 280, '麒麟9000S，卫星通话', 1, 1),
('索尼WH-1000XM5', 3, 2699.00, 2999.00, 180, 400, '旗舰降噪耳机，30小时续航', 1, 0),
('小米手环8 Pro', 5, 399.00, 499.00, 500, 1000, '健康监测，运动追踪', 0, 1);

-- 插入收货地址
INSERT INTO addresses (user_id, receiver_name, phone, province, city, district, detail_address, is_default) VALUES
(1, '张三', '13800138000', '北京市', '北京市', '朝阳区', '建国路88号SOHO现代城', 1),
(1, '李四', '13900139000', '上海市', '上海市', '浦东新区', '世纪大道100号', 0),
(2, '王五', '13700137000', '广东省', '深圳市', '南山区', '科技园南区', 1);

-- 插入订单示例
INSERT INTO orders (order_no, user_id, total_amount, discount_amount, pay_amount, status, receiver_name, receiver_phone, receiver_address, pay_time) VALUES
('20260614103000ABC1', 1, 9898.00, 0.00, 9898.00, 'pending', '张三', '13800138000', '北京市朝阳区建国路88号', NULL),
('20260613152000DEF2', 1, 14999.00, 0.00, 14999.00, 'paid', '张三', '13800138000', '北京市朝阳区建国路88号', '2026-06-13 15:30:00'),
('20260612110000GHI3', 2, 7999.00, 0.00, 7999.00, 'completed', '王五', '13700137000', '深圳市南山区科技园南区', '2026-06-12 11:15:00');

-- 插入订单明细
INSERT INTO order_items (order_id, product_id, product_name, product_price, quantity, subtotal) VALUES
(1, 1, 'iPhone 15 Pro', 7999.00, 1, 7999.00),
(1, 5, 'AirPods Pro 2', 1899.00, 1, 1899.00),
(2, 3, 'MacBook Pro 14', 14999.00, 1, 14999.00),
(3, 1, 'iPhone 15 Pro', 7999.00, 1, 7999.00);

-- 插入购物车示例
INSERT INTO cart (user_id, product_id, quantity, selected) VALUES
(1, 1, 1, 1),
(1, 5, 2, 1),
(2, 3, 1, 1);

-- ========================================
-- 索引
-- ========================================
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_no ON orders(order_no);
CREATE INDEX idx_order_items_order ON order_items(order_id);