-- 这一课介绍什么是 SQL 的聚集函数，如何利用它们汇总表的数据。

-- 9.1 聚集函数
-- 1，确定表中行数（或者满足某个条件或包含某个特定值的行数）
-- 2，获得表中某些行的和；
-- 3，找出表列（或所有行或某些特定的行）的最大值、最小值、平均值。
--
-- 聚集函数（aggregate function） 对某些行运行的函数，计算并返回一个值。
--
-- AVG()    返回某列的平均值
-- COUNT()  返回某列的行数
-- MAX()    返回某列的最大值
-- MIN()    返回某列的最小值
-- SUM()    返回某列值之和

-- 9.1.1 AVG() 函数：返回平均值
SELECT AVG(prod_price) AS avg_price
FROM Products;
-- AVG() 也可以用来确定特定列或行的平均值。
-- AVG() 函数会忽略值为 NULL 的行
SELECT AVG(prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

-- 9.1.2 COUNT() 函数进行计数
-- COUNT(*) 不忽略 NULL 值
-- COUNT(column) 忽略 NULL 值
SELECT COUNT(*) AS num_cust
FROM Customers;
-- 下面的例子只对具有电子邮件地址的客户计数：
SELECT COUNT(cust_email) AS num_cust
FROM Customers;

-- 9.1.3 MAX() 函数，返回指定列中的最大值，忽略列值为 NULL 的行
SELECT MAX(prod_price) AS max_price
FROM Products;

-- 9.1.4 MIN() 函数，返回指定列中的最小值，忽略列值为 NULL 的行
SELECT MIN(prod_price) AS min_price
FROM Products;

-- 9.1.5 SUM() 函数，返回指定列值的和（总计）
SELECT SUM(quantity) AS items_ordered
FROM OrderItems
WHERE order_num = 20005;
-- SUM()也可以用来合计计算值。
-- 所有聚集函数都可用来执行多个列上的计算。
SELECT SUM(quantity * item_price) AS total_price
FROM OrderItems
WHERE order_num = 20005;

-- 9.2 聚集不同值
-- 对所有行执行计算，指定 ALL 参数或不指定参数（因为 ALL 是默认行为）。
-- 只包含不同的值，指定 DISTINCT 参数
--
-- DISTINCT 必须使用列名，不能用于计算或表达式。
--
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

-- 9.3 组合聚集函数
-- SELECT 语句可根据需要包含多个聚集函数
SELECT COUNT(*)        AS num_items,
       MIN(prod_price) AS price_min,
       MAX(prod_price) AS price_max,
       AVG(prod_price) AS price_avg
FROM Products;

-- 9.4 小结
-- 聚集函数用来汇总数据。SQL 支持 5 个聚集函数，可以用多种方法使用
-- 它们，返回所需的结果。这些函数很高效，它们返回结果一般比你在自
-- 己的客户端应用程序中计算要快得多。

-- 9.5 挑战题
-- 9.5.1 编写 SQL 语句，确定已售出产品的总数（使用 OrderItems 中的
--       quantity 列）
SELECT SUM(quantity) AS total
FROM OrderItems;

-- 9.5.2 修改刚刚创建的语句，确定已售出产品项（prod_item）BR01 的
--       总数。
SELECT SUM(quantity) AS total
FROM OrderItems
WHERE prod_id = 'BR01';

-- 9.5.3 编写 SQL 语句，确定 Products 表中价格不超过 10 美元的最贵产品
--       的价格（prod_price）。将计算所得的字段命名为 max_price。
SELECT MAX(prod_price) AS max_price
FROM Products
WHERE prod_price < 10;
