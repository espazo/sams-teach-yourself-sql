-- 这一课讲授如何使用 SELECT 语句的 ORDER BY 子句，根据需要排序检索出的数据
-- 子句（clause）通常由一个关键字加上所提供的数据组成

-- 3.1 排序数据
-- 可以通过 ORDER BY 子句取一个或多个列的名字，据此对输出进行排序
-- 应保证 ORDER BY 子句是最后一条语句，否则将报错
SELECT prod_name
FROM products
ORDER BY prod_name;

-- 3.2 按多个列排序
-- 可以首先根据价格排序，如果价格相同则按照名称排序
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price, prod_name;

-- 3.3 按列位置排序
-- 可以混合列名，和列在 SELECT 的相对序列使用
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY 2, 3;

-- 3.4 指定排序方向
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC;
-- 排序方向执行某一列
-- DESCENDING 和 DESC 是一样的
SELECT prod_id, prod_price, prod_name
FROM products
ORDER BY prod_price DESC, prod_name;

-- 3.6 挑战题
-- 3.6.1 编写 SQL 语句，从 Customers 中检索所有的顾客名称（cust_names），
--       并按从 Z 到 A 的顺序显示结果。
SELECT cust_name
FROM customers
ORDER BY cust_name DESC;

-- 3.6.2 编写 SQL 语句，从 Orders 表中检索顾客 ID（cust_id）和订单号
--       （order_num），并先按顾客 ID 对结果进行排序，再按订单日期倒序
--       排列。
SELECT cust_id, order_num
FROM orders
ORDER BY cust_id, order_date DESC;

-- 3.6.3 显然，我们的虚拟商店更喜欢出售比较贵的物品，而且这类物品有很多。
--       编写 SQL 语句，显示 OrderItems 表中的数量和价格（item_price），
--       并按数量由多到少、价格由高到低排序。

SELECT quantity, item_price
FROM orderitems
ORDER BY quantity DESC, item_price DESC;

-- 3.6.4 下面的 SQL 语句有问题吗？（尝试在不运行的情况下指出。）
--       SELECT vend_name,
--       FROM Vendors
--       ORDER vend_name DESC;
-- 有问题：最后一行里少了一个关键字 BY，ORDER BY 应该成对出现

