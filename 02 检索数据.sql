-- 2.2 检索单个列
SELECT prod_name
FROM Products;

-- 2.3 检索多个列
SELECT prod_id, prod_name, prod_price
FROM Products;

-- 2.4 检索所有列
-- 缺点：影响性能
-- 优点：可以检索未知的列
SELECT *
FROM Products;

-- 2.5 检索不同的值
-- 会返回 9 行数据，但是只有三个不同
SELECT vend_id
FROM Products;
-- 使用 DISTINCT 关键字，可以只返回不同的值
SELECT DISTINCT vend_id
FROM Products;
-- 参考：DISTINCT 是作用在所有列上面的
SELECT DISTINCT vend_id, prod_price FROM Products;
SELECT vend_id, prod_price FROM Products;

-- 2.6 限制结果
-- 只取前 5 行
-- 但是不同的数据库，用法可能不同，下面是 mariadb 的用法
SELECT prod_name
FROM Products
LIMIT 5;
-- 返回从第 5 行起的 5 行数据
-- 第一个被检索的行是第 0 行
SELECT prod_name
FROM Products
LIMIT 5 OFFSET 5;
-- MySQL, MariaDB, SQLite 的简要的写法
-- 相当于 LIMIT 4 OFFSET 3 简写为下面这种形式
SELECT prod_name
FROM Products
LIMIT 3, 4

-- 2.7 使用注释
-- 这是一条注释
# 这是单行注释
/* 这是
   多行注释
 */

-- 2.9 挑战题
-- 2.9.1 编写 SQL 语句，从 Customer 表中检索所有的 ID（cust_id）
SELECT cust_id
FROM Customers;

-- 2.9.2 OrderItems 表包含了所有已订购的产品（有些已被订购多次）。编写
--       SQL 语句，检索并列出已订购产品（prod_id）的清单（不用列每个
--       订单，只列出不同产品的清单）。提示：最终应该显示 7 行。
SELECT DISTINCT prod_id
FROM OrderItems;

-- 2.9.3 编写 SQL语句，检索 Customers 表中所有的列，再编写另外的 SELECT
--       语句，仅检索顾客的 ID。使用注释，注释掉一条 SELECT 语句，以便
--       运行另一条 SELECT 语句。（当然，要测试这两个语句。
SELECT *
# SELECT cust_id
FROM Customers;
