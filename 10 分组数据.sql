-- 这一课介绍如何分组数据，以便汇总表内容的子集。这涉及两个新
-- SELECT 语句子句：GROUP BY 子句和 HAVING 子句。

-- 10.1 数据分组
-- 下面的例子返回供应商 DLL01 提供的产品数目
--
-- 使用分组可以将数据分为多个逻辑组，
-- 对每个组进行聚集计算。
--
SELECT COUNT(*) AS num_prods
FROM Products
WHERE vend_id = 'DLL01';

-- 10.2 创建分组
-- 分组是使用 SELECT 语句的 GROUP BY 子句建立的。
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;
--
-- 在使用 GROUP BY 子句前，需要知道一些重要的规定。
-- 1，GROUP BY 子句可以包含任意数目的列，因而可以对分组进行嵌套，
--    更细致地进行数据分组。
-- 2，如果在 GROUP BY 子句中嵌套了分组，数据将在最后指定的分组上进
--    行汇总。换句话说，在建立分组时，指定的所有列都一起计算（所以
--    不能从个别的列取回数据）。
-- 3，GROUP BY 子句中列出的每一列都必须是检索列或有效的表达式（但
--    不能是聚集函数）。如果在 SELECT 中使用表达式，则必须在 GROUP BY
--    子句中指定相同的表达式。不能使用别名。
-- 4，大多数 SQL 实现不允许 GROUP BY 列带有长度可变的数据类型（如文
--    本或备注型字段）。
-- 5，除聚集计算语句外，SELECT 语句中的每一列都必须在 GROUP BY 子句
--    中给出。
-- 6，如果分组列中包含具有 NULL 值的行，则 NULL 将作为一个分组返回。
--    如果列中有多行 NULL 值，它们将分为一组。
-- 7，GROUP BY 子句必须出现在 WHERE 子句之后，ORDER BY 子句之前。

-- 10.3 过滤分组
-- HIVING 和 WHERE 它们的句法是相同的，只是关键字有差别。
-- 但是 HIVING 可以放在 GROUP BY 后面
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING COUNT(*) >= 2;
-- 测试（通过）：HAVING 使用别名
SELECT cust_id, COUNT(*) AS orders
FROM Orders
GROUP BY cust_id
HAVING orders >= 2;
--
-- WHERE 在数据分组前进行过滤，HAVING 在数
-- 据分组后进行过滤。
--
-- 有没有在一条语句中同时使用 WHERE 和 HAVING 子句的需要呢？
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT (*) >= 2;

-- 10.4 分组和排序
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3;
-- 结合 ORDER BY 使用
SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;

-- 10.5 SELECT 子句的顺序
--      SELECT      要返回的列或表达式   是
--      FROM        从中检索数据的表    仅在从表选择数据时使用
--      WHERE       行级过滤           否
--      GROUP BY    分组说明           仅在按组计算聚集时使用
--      HAVING      组级过滤           否
--      ORDER BY    输出排序顺序       否

-- 10.6 小结
-- 上一课介绍了如何用 SQL 聚集函数对数据进行汇总计算。这一课讲授了
-- 如何使用 GROUP BY 子句对多组数据进行汇总计算，返回每个组的结果。
-- 我们看到了如何使用 HAVING 子句过滤特定的组，还知道了 ORDER BY
-- 和 GROUP BY 之间以及 WHERE 和 HAVING 之间的差异。

-- 10.7 挑战题
-- 10.7.1 OrderItems 表包含每个订单的每个产品。编写 SQL 语句，返回每个
--        订单号（order_num）各有多少行数（order_lines），并按 order_lines
--        对结果进行排序。
SELECT order_num, COUNT(*) AS order_lines
FROM OrderItems
GROUP BY order_num
ORDER BY order_lines;

-- 10.7.2 编写 SQL 语句，返回名为 cheapest_item 的字段，该字段包含每个
--        供应商成本最低的产品（使用 Products 表中的 prod_price），然后
--        从最低成本到最高成本对结果进行排序。
SELECT prod_id, MIN(prod_price) AS cheapest_item
FROM Products
GROUP BY prod_id
ORDER BY cheapest_item;

-- 10.7.3 确定最佳顾客非常重要，请编写 SQL 语句，返回至少含 100 项的所有
--        订单的订单号（OrderItems 表中的 order_num）。
SELECT order_num
FROM OrderItems
GROUP BY order_num
HAVING SUM(quantity) >= 100
ORDER BY order_num;

-- 10.7.4 确定最佳顾客的另一种方式是看他们花了多少钱。编写 SQL 语句，
--        返回总价至少为 1000 的所有订单的订单号（OrderItems 表中的
--        order_num）。提示：需要计算总和（item_price 乘以 quantity）。
--        按订单号对结果进行排序。
SELECT order_num, SUM(quantity * item_price) AS total_price
FROM OrderItems
GROUP BY order_num
HAVING SUM(quantity * item_price) >= 1000
ORDER BY order_num;

-- 10.7.5 下面的 SQL 语句有问题吗？（尝试在不运行的情况下指出。）
# SELECT order_num, COUNT(*) AS items
# FROM OrderItems
# GROUP BY items
# HAVING COUNT(*) >= 3
# ORDER BY items, order_num;
-- 有问题：GROUP BY 里不应该出现聚合函数，而是实际的列
