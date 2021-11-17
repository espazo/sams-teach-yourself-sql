-- 本课讲解另外一些联结（包括它们的含义和使用方法），介绍如何使用表
-- 别名，如何对被联结的表使用聚集函数。

-- 13.1 使用表别名
-- SQL 除了可以对列名和计算字段使用别名，还允许给表名起别名。这样
-- 做有两个主要理由：
--
-- 1，缩短 SQL 语句；
-- 2，允许在一条 SELECT 语句中多次使用相同的表。
SELECT cust_name, cust_contact
FROM Customers AS C,
     Orders AS O,
     OrderItems AS OI
WHERE C.cust_id = O.cust_id
  AND OI.order_num = O.order_num
  AND prod_id = 'RGAN01';

-- 13.2 使用不同类型的联结
-- 迄今为止，我们使用的只是内联结或等值联结的简单联结。现在来看
-- 三种其他联结：自联结（self-join）、自然联结（natural join）和外联结
-- （outer join）。

-- 13.2.1 自联结
--
-- 用自联结而不用子查询
-- 自联结通常作为外部语句，用来替代从相同表中检索数据的使用子查
-- 询语句。虽然最终的结果是相同的，但许多 DBMS 处理联结远比处理
-- 子查询快得多。应该试一下两种方法，以确定哪一种的性能更好。
--
-- 使用子查询
SELECT cust_id, cust_name, cust_contact
FROM Customers
WHERE cust_name = (SELECT cust_name
                   FROM Customers
                   WHERE cust_contact = 'Jim Jones');
-- 使用自联结
SELECT c1.cust_id, c1.cust_name, c1.cust_contact
FROM Customers AS c1,
     Customers AS c2
WHERE c1.cust_name = c2.cust_name
  AND c2.cust_contact = 'Jim Jones';

-- 13.2.2 自然联结
-- 自然联结排除多次出现，使每一列只返回一次。
-- 怎样完成这项工作呢？答案是，系统不完成这项工作，由你自己完成它。
SELECT C.*,
       O.order_num,
       O.order_date,
       OI.prod_id,
       OI.quantity,
       OI.item_price
FROM Customers AS C,
     Orders AS O,
     OrderItems AS OI
WHERE C.cust_id = O.cust_id
  AND OI.order_num = O.order_num
  AND prod_id = 'RGAN01';

-- 13.2.3 外联结
-- 许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含
-- 没有关联行的那些行。
SELECT Customers.cust_id, Orders.order_num
FROM Customers
         LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;
-- 右边外联结，使用关键字 RIGHT
SELECT Customers.cust_id, Orders.order_num
FROM Customers
         RIGHT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;
-- 全外联结，使用关键字 FULL，但是 mariadb 不支持
# SELECT Customers.cust_id, Orders.order_num
# FROM Customers
# FULL OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 13.3 使用带聚集函数的联结
SELECT Customers.cust_id,
       COUNT(Orders.order_num) AS num_ord
FROM Customers
         INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;
-- 聚集函数也可以方便地与其他联结一起使用。
SELECT Customers.cust_id,
       COUNT(Orders.order_num) AS num_ord
FROM Customers
         LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

-- 13.4 使用联结和联结条件
-- 在总结讨论联结的这两课前，有必要汇总一下联结及其使用的要点。
--
-- 1，注意所使用的联结类型。一般我们使用内联结，但使用外联结也有效。
-- 2，关于确切的联结语法，应该查看具体的文档，看相应的 DBMS 支持何
--    种语法（大多数 DBMS 使用这两课中描述的某种语法）
-- 3，保证使用正确的联结条件（不管采用哪种语法），否则会返回不正确
--    的数据。
-- 4，应该总是提供联结条件，否则会得出笛卡儿积。
-- 5，在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结
--    类型。虽然这样做是合法的，一般也很有用，但应该在一起测试它们
--    前分别测试每个联结。这会使故障排除更为简单。

-- 13.5 小结
-- 本课是上一课的延续，首先讲授了如何以及为什么使用别名，然后讨论
-- 不同的联结类型以及每类联结所使用的语法。我们还介绍了如何与联结
-- 一起使用聚集函数，以及在使用联结时应该注意的问题。

-- 13.6 挑战题
-- 13.6.1 使用 INNER JOIN 编写 SQL语句，以检索每个顾客的名称（Customers
--        表中的 cust_name）和所有的订单号（Orders 表中的 order_num）。
SELECT Customers.cust_name, Orders.order_num
FROM Customers
         INNER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 13.6.2 修改刚刚创建的 SQL 语句，仅列出所有顾客，即使他们没有下过订单。
SELECT Customers.cust_name, Orders.order_num
FROM Customers
         LEFT OUTER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 13.6.3 使用 OUTER JOIN 联结 Products 表和 OrderItems 表，返回产品名
--        称（prod_name）和与之相关的订单号（order_num）的列表，并按
--        商品名称排序。
SELECT Products.prod_name, OrderItems.order_num
FROM Products
         LEFT JOIN OrderItems ON Products.prod_id = OrderItems.prod_id
ORDER BY prod_name;

-- 13.6.4 修改上一题中创建的 SQL 语句，使其返回每一项产品的总订单数
--       （不是订单号）。
SELECT Products.prod_name,
       COUNT(OrderItems.order_num) AS order_num
FROM Products
         LEFT JOIN OrderItems ON Products.prod_id = OrderItems.prod_id
GROUP BY Products.prod_name;

-- 13.6.5 编写 SQL语句，列出供应商（Vendors 表中的 vend_id）及其可供产品
--        的数量，包括没有产品的供应商。你需要使用 OUTER JOIN 和 COUNT()
--        聚合函数来计算 Products 表中每种产品的数量。注意：vend_id 列
--        会显示在多个表中，因此在每次引用它时都需要完全限定它。
SELECT Vendors.vend_id, COUNT(Products.prod_id)
FROM Vendors
LEFT OUTER JOIN Products ON Vendors.vend_id = Products.vend_id
GROUP BY Vendors.vend_id;
