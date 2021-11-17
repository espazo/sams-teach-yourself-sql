-- 本课讲述如何利用 UNION 操作符将多条 SELECT 语句组合成一个结
-- 果集。

-- 14.1 组合查询
-- 多数 SQL 查询只包含从一个或多个表中返回数据的单条 SELECT 语句。
-- 但是，SQL 也允许执行多个查询（多条 SELECT 语句），并将结果作为一
-- 个查询结果集返回。这些组合查询通常称为并（union）或复合查询
-- （compound query）
--
-- 主要有两种情况需要使用组合查询：
-- 1，在一个查询中从不同的表返回结构数据；
-- 2，对一个表执行多个查询，按一个查询返回数据。
--
-- 多数情况下，组合相同表的两个查询所完成的工作与具有多个 WHERE
-- 子句条件的一个查询所完成的工作相同。

-- 14.2 创建组合查询
-- 可用 UNION 操作符来组合数条 SQL 查询。利用 UNION，可给出多条
-- SELECT 语句，将它们的结果组合成一个结果集。

-- 14.2.1 使用 UNION
-- 使用 UNION 很简单，所要做的只是给出每条 SELECT 语句，在各条语句
-- 之间放上关键字 UNION。
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';

-- 14.2.2 UNION 规则
--
-- 1，UNION 必须由两条或两条以上的 SELECT 语句组成，语句之间用关键字
--    UNION 分隔（因此，如果组合四条 SELECT 语句，将要使用三个 UNION
--    关键字）
-- 2，UNION 中的每个查询必须包含相同的列、表达式或聚集函数（不过，
--    各个列不需要以相同的次序列出）。
-- 3，列数据类型必须兼容：类型不必完全相同，但必须是 DBMS 可以隐含
--    转换的类型（例如，不同的数值类型或不同的日期类型）
--
-- UNION 的列名：会返回第一个名字。排序也需要用到这个别名

-- 14.2.3 包含或取消重复行
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION ALL
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All';
-- UNION 与 WHERE：如果需要重复的行，那么 WHERE 则不能替代 UNION

-- 14.2.4 对组合查询结果排序
-- SELECT 语句的输出用 ORDER BY 子句排序。在用 UNION 组合查询时，只
-- 能使用一条 ORDER BY 子句，它必须位于最后一条 SELECT 语句之后。对
-- 于结果集，不存在用一种方式排序一部分，而又用另一种方式排序另一
-- 部分的情况，因此不允许使用多条 ORDER BY 子句。
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_state IN ('IL', 'IN', 'MI')
UNION
SELECT cust_name, cust_contact, cust_email
FROM Customers
WHERE cust_name = 'Fun4All'
ORDER BY cust_name, cust_contact;
--
-- 其他类型的 UNION
--
-- 1，EXCEPT（有时称为 MINUS）可用来检索只在第一个表中存在而在第二个表中不存在的行；
-- 2，而 INTERSECT可用来检索两个表中都存在的行。

-- 14.3 小结
-- 这一课讲授如何用 UNION 操作符来组合 SELECT 语句。利用 UNION，可以把
-- 多条查询的结果作为一条组合查询返回，不管结果中有无重复。使用 UNION
-- 可极大地简化复杂的 WHERE 子句，简化从多个表中检索数据的工作。

-- 14.4 挑战题
-- 14.4.1 编写 SQL 语句，将两个 SELECT 语句结合起来，以便从 OrderItems
--        表中检索产品 ID（prod_id）和 quantity。其中，一个 SELECT 语
--        句过滤数量为 100 的行，另一个 SELECT 语句过滤 ID 以 BNBG 开头的
--        产品。按产品 ID 对结果进行排序。
SELECT prod_id, quantity
FROM OrderItems
WHERE quantity = 100
UNION
SELECT prod_id, quantity
FROM OrderItems
WHERE prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 14.4.2 重写刚刚创建的 SQL 语句，仅使用单个 SELECT 语句。
SELECT prod_id, quantity
FROM OrderItems
WHERE quantity = 100
   OR prod_id LIKE 'BNBG%'
ORDER BY prod_id;

-- 14.4.3 我知道这有点荒谬，但这节课中的一个注释提到过。编写 SQL 语句，
--        组合 Products 表中的产品名称（prod_name）和 Customers 表中的
--        顾客名称（cust_name）并返回，然后按产品名称对结果进行排序。
SELECT prod_name
FROM Products
UNION
SELECT cust_name
FROM Customers
ORDER BY prod_name;

-- 14.5.4 下面的 SQL 语句有问题吗？（尝试在不运行的情况下指出。）
# SELECT cust_name, cust_contact, cust_email
# FROM Customers
# WHERE cust_state = 'MI'
# ORDER BY cust_name;
# UNION
# SELECT cust_name, cust_contact, cust_email
# FROM Customers
# WHERE cust_state = 'IL'ORDER BY cust_name;
-- 有问题的：在组合查询里面，只能在最后一个查询里面使用 ORDER BY
