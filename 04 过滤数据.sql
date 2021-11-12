-- 这一课将讲授如何使用 SELECT 语句的 WHERE 子句指定搜索条件。

-- 4.1 使用 WHERE 子句
-- 搜索条件（search criteria）过滤条件（filter condition）
-- WHERE 应当在 FROM 子句后出现
SELECT prod_name, prod_price
FROM Products
WHERE prod_price = 3.49;

-- 4.2 WHERE 子句操作符
-- = 等于
-- <> 不等于
-- != 不等于
-- < 小于
-- <= 小于等于
-- !< 不小于
-- > 大于
-- >= 等于等于
-- !> 不大于
-- BETWEEN 指定在两个值之间
-- IS NULL 为 NULL 值

-- 4.2.1 检查单个值
SELECT prod_name, prod_price
FROM Products
WHERE prod_price < 10;

-- 4.2.2 不匹配检查
-- 字符类型需要用单引号，数值类型不用
SELECT vend_id, prod_name
FROM Products
WHERE vend_id <> 'DLL01';

-- 4.2.3 范围值检查
-- 连接范围的两个值中间需要用到 AND 关键字
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 5 AND 10;

-- 4.2.4 空值检查
SELECT cust_name
FROM Customers
WHERE cust_email IS NULL;

-- 4.3 挑战题
-- 4.3.1 编写 SQL 语句，从 Products 表中检索产品 ID（prod_id）和产品名
--       称（prod_name），只返回价格为 9.49 美元的产品。
SELECT prod_id, prod_name
FROM Products
WHERE prod_price = 9.49;

-- 4.3.2 编写 SQL 语句，从 Products 表中检索产品 ID（prod_id）和产品名
--       称（prod_name），只返回价格为 9 美元或更高的产品。
SELECT prod_id, prod_name
FROM Products
WHERE prod_price >= 9;

-- 4.3.3 结合第 3 课和第 4 课编写 SQL 语句，从 OrderItems 表中检索出所有
--       不同订单号（order_num），其中包含 100 个或更多的产品。
SELECT DISTINCT order_num
FROM OrderItems
WHERE quantity >= 100;

-- 4.3.4 编写 SQL 语句，返回 Products 表中所有价格在 3 美元到 6 美元之间
--       的产品的名称（prod_name）和价格（prod_price），然后按价格对
--       结果进行排序。（本题有多种解决方案，我们在下一课再讨论，不过
--       你可以使用目前已学的知识来解决它。
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 3 AND 6
ORDER BY prod_price;
