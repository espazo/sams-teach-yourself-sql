-- 这一课介绍什么是子查询，如何使用它们。

-- 11.1 子查询
--
-- 查询（query）
-- 任何 SQL 语句都是查询。但此术语一般指 SELECT 语句。

-- 11.2 利用子查询进行过滤
-- 假如需要列出订购物品 RGAN01 的所有顾客，应该怎样检索？
-- 1，检索包含物品 RGAN01 的所有订单的编号。
-- 2，检索具有前一步骤列出的订单编号的所有顾客的 ID。
-- 3，检索前一步骤返回的所有顾客 ID 的顾客信息。
--
-- 分步查询 1
SELECT order_num
FROM OrderItems
WHERE prod_id = 'RGAN01';
-- 分步查询 2
SELECT cust_id
FROM Orders
WHERE order_num IN (20007, 20008);
--
-- 使用子查询
SELECT cust_id
FROM Orders
WHERE order_num IN (SELECT order_num
                    FROM OrderItems
                    WHERE prod_id = 'RGAN01');
--
-- 分步查询 3：顾客信息
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (1000000004, 1000000005);
--
-- 使用子查询
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));
--
-- 只能是单列
-- 作为子查询的 SELECT 语句只能查询单个列。企图检索多个列将返回
-- 错误。
--
-- 子查询和性能
-- 这里给出的代码有效，并且获得了所需的结果。但是，使用子查询并
-- 不总是执行这类数据检索的最有效方法。更多的论述，请参阅第 12
-- 课，其中将再次给出这个例子。
--

-- 11.3 作为计算字段使用子查询
-- 分步查询一个顾客的订单统计
SELECT COUNT(*) AS orders
FROM Orders
WHERE cust_id = 1000000001;
-- 通过子查询
SELECT cust_name,
       cust_state,
       (SELECT COUNT(*)
        FROM Orders
        WHERE Orders.cust_id = Customers.cust_id) AS orders
FROM Customers
ORDER BY cust_name;
--
-- 完全限定名：如果在 SELECT 语句中操作多个表，就应使用完全限定列名来避免歧义。

-- 11.4 小结
-- 这一课学习了什么是子查询，如何使用它们。子查询常用于 WHERE 子
-- 句的 IN 操作符中，以及用来填充计算列。我们举了这两种操作类型的
-- 例子。

-- 11.5 挑战题
-- 11.5.1 使用子查询，返回购买价格为 10 美元或以上产品的顾客列表。你需
--        要使用 OrderItems 表查找匹配的订单号（order_num），然后使用
--        Order 表检索这些匹配订单的顾客 ID（cust_id）。
SELECT *
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE item_price >= 10));

-- 11.5.2 你想知道订购 BR01 产品的日期。编写 SQL 语句，使用子查询来确定
--        哪些订单（在 OrderItems 中）购买了 prod_id 为 BR01 的产品，然
--        后从 Orders 表中返回每个产品对应的顾客 ID（cust_id）和订单日
--        期（order_date）。按订购日期对结果进行排序。
SELECT order_date
FROM Orders
WHERE order_num IN (SELECT order_num
                    FROM OrderItems
                    WHERE prod_id = 'BR01');

-- 11.5.3 现在我们让它更具挑战性。在上一个挑战题，返回购买 prod_id 为
--        BR01 的产品的所有顾客的电子邮件（Customers 表中的 cust_email）。
--        提示：这涉及 SELECT 语句，最内层的从 OrderItems 表返回 order_num，
--        中间的从 Customers 表返回 cust_id。
SELECT cust_email
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'BR01'));

-- 11.5.4 我们需要一个顾客 ID 列表，其中包含他们已订购的总金额。编写 SQL
--        语句，返回顾客 ID（Orders 表中的 cust_id），并使用子查询返回
--        total_ordered 以便返回每个顾客的订单总数。将结果按金额从大到
--        小排序。提示：你之前已经使用 SUM()计算订单总数。
SELECT cust_id,
       (SELECT SUM(quantity * item_price)
        FROM OrderItems
        WHERE Orders.order_num = OrderItems.order_num) AS total_ordered
FROM Orders
ORDER BY total_ordered DESC;

-- 11.5.5 再来。编写 SQL 语句，从 Products 表中检索所有的产品名称（prod_
--        name），以及名为 quant_sold 的计算列，其中包含所售产品的总数
--        （在 OrderItems 表上使用子查询和 SUM(quantity)检索）。
SELECT prod_name,
       (SELECT COUNT(*)
        FROM OrderItems
        WHERE Products.prod_id = OrderItems.prod_id) AS quant_sold
FROM Products;
