-- 这一课讲授如何组合 WHERE 子句以建立功能更强、更高级的搜索条件。
-- 我们还将学习如何使用 NOT 和 IN 操作符

-- 5.1 组合 WHERE 子句
-- 操作符（operator）用来联结或改变 WHERE 子句中的子句的关键字，也称为逻辑操作符（logical operator）。

-- 5.1.1 AND 操作符
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01'
  AND prod_price <= 4;

-- 5.1.2 OR 操作符
SELECT prod_id, prod_price, prod_name
FROM Products
WHERE vend_id = 'DLL01'
   OR vend_id = 'BRS01';

-- 5.1.3 求值顺序
SELECT prod_name, prod_price
FROM Products
WHERE vend_id = 'DLL01'
   OR vend_id = 'BRS01'
    AND prod_price >= 10;
-- 此问题的解决方法是使用圆括号对操作符进行明确分组
SELECT prod_name, prod_price
FROM Products
WHERE (vend_id = 'DLL01' OR vend_id = 'BRS01')
  AND prod_price >= 10;

-- 5.2 IN 操作符
SELECT prod_name, prod_price
FROM Products
WHERE vend_id IN ('DLL01', 'BRS01')
ORDER BY prod_name;
-- WHERE 子句中用来指定要匹配值的清单的关键字，功能与 OR 相当。
SELECT prod_name, prod_price
FROM Products
WHERE vend_id = 'DLL01'
   OR vend_id = 'BRS01'
ORDER BY prod_name;

-- 5.3 NOT 操作符
SELECT prod_name
FROM Products
WHERE NOT vend_id = 'DLL01'
ORDER BY prod_name;
-- 也可以这样达到同样的效果
SELECT prod_name
FROM Products
WHERE vend_id <> 'DLL01'
ORDER BY prod_name;

-- 5.5 挑战题
-- 5.5.1 编写 SQL 语句，从 Vendors 表中检索供应商名称（vend_name），仅返
--       回加利福尼亚州的供应商（这需要按国家[USA]和州[CA]进行过滤，
--       没准其他国家也存在一个加利福尼亚州）。提示：过滤器需要匹配字
--       符串。
SELECT vend_name
FROM Vendors
WHERE vend_country = 'USA'
  AND vend_state = 'CA';

-- 5.5.2 编写 SQL 语句，查找所有至少订购了总量 100 个的 BR01、BR02 或
--       BR03 的订单。你需要返回 OrderItems 表的订单号（order_num）、
--       产品 ID（prod_id）和数量，并按产品 ID 和数量进行过滤。提示：
--       根据编写过滤器的方式，可能需要特别注意求值顺序。
SELECT order_num, prod_id, quantity
FROM OrderItems
WHERE quantity > 100
  AND prod_id IN ('BR01', 'BR02');

-- 5.5.3 现在，我们回顾上一课的挑战题。编写 SQL 语句，返回所有价格在 3
--       美元到 6美元之间的产品的名称（prod_name）和价格（prod_price）。
--       使用 AND，然后按价格对结果进行排序。
SELECT prod_name, prod_price
FROM Products
WHERE prod_price >= 3 AND prod_price <= 6;
-- 也可以这样
SELECT prod_name, prod_price
FROM Products
WHERE prod_price BETWEEN 3 AND 6;


