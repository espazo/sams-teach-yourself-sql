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

