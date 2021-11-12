-- 这一课会介绍什么是联结，为什么使用联结，如何编写使用联结的
-- SELECT 语句。

-- 12.1 联结（join）
-- SQL 最强大的功能之一就是能在数据查询的执行中联结（join）表。

-- 12.1.1 表关系
-- 将这些数据与产品信息分开存储的理由是
-- 1，同一供应商生产的每个产品，其供应商信息都是相同的，对每个产品
--    重复此信息既浪费时间又浪费存储空间；
-- 2，如果供应商信息发生变化，例如供应商迁址或电话号码变动，只需修
--    改一次即可；
-- 3，如果有重复数据（即每种产品都存储供应商信息），则很难保证每次
--    输入该数据的方式都相同。不一致的数据在报表中就很难利用。
--
-- 利用供应商 ID 能从 Vendors 表中找出相应供应商的详细信息。
-- 这样做的好处是：
-- 1，供应商信息不重复，不会浪费时间和空间；
-- 2，如果供应商信息变动，可以只更新 Vendors 表中的单个记录，相关表
--    中的数据不用改动；
-- 3，由于数据不重复，数据显然是一致的，使得处理数据和生成报表更简单。
--
-- 总之，关系数据可以有效地存储，方便地处理。因此，关系数据库的可
-- 伸缩性远比非关系数据库要好。
--
-- 可伸缩（scale）
-- 能够适应不断增加的工作量而不失败。设计良好的数据库或应用程序
-- 称为可伸缩性好（scale well）

-- 12.1.2 为什么使用联结
-- 怎样用一条 SELECT 语句就检索出数据呢？
-- 答案是使用联结。

-- 12.2 创建联结
-- 创建联结非常简单，指定要联结的所有表以及关联它们的方式即可。
SELECT vend_name, prod_name, prod_price
FROM Vendors,
     Products
WHERE Vendors.vend_id = Products.vend_id;

-- 12.2.1 WHERE 子句的重要性
--
-- 笛卡儿积（cartesian product）
-- 由没有联结条件的表关系返回的结果为笛卡儿积。检索出的行的数目
-- 将是第一个表中的行数乘以第二个表中的行数。
--
-- 有时，返回笛卡儿积的联结，也称叉联结（cross join）。
SELECT vend_name, prod_name, prod_price
FROM Vendors,
     Products;

-- 12.2.2 内联结
-- 目前为止使用的联结称为等值联结（equijoin），它基于两个表之间的相
-- 等测试。这种联结也称为内联结（inner join）。
SELECT vend_name, prod_name, prod_price
FROM Vendors
         INNER JOIN Products on Vendors.vend_id = Products.vend_id;

-- 12.2.3 联结多个表
SELECT prod_name, vend_name, prod_price, quantity
FROM OrderItems,
     Products,
     Vendors
WHERE Products.vend_id = Vendors.vend_id
  AND OrderItems.prod_id = Products.prod_id
  AND order_num = 20007;
--
-- 返回订购产品 RGAN01的顾客列表
SELECT cust_name, cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
                  FROM Orders
                  WHERE order_num IN (SELECT order_num
                                      FROM OrderItems
                                      WHERE prod_id = 'RGAN01'));
-- 用联结的相同查询
SELECT cust_name, cust_contact
FROM Customers,
     Orders,
     OrderItems
WHERE Customers.cust_id = Orders.cust_id
  AND OrderItems.order_num = Orders.order_num
  AND prod_id = 'RGAN01';

-- 12.3 小结
-- 联结是 SQL 中一个最重要、最强大的特性，有效地使用联结需要对关系
-- 数据库设计有基本的了解。本课在介绍联结时，讲述了一些关系数据库
-- 设计的基本知识，包括等值联结（也称为内联结）这种最常用的联结。
-- 下一课将介绍如何创建其他类型的联结。

-- 12.4 挑战题
-- 12.4.1 编写 SQL 语句，返回 Customers 表中的顾客名称（cust_name）和
--        Orders 表中的相关订单号（order_num），并 按顾客名称再按订单号
--        对结果进行排序。实际上是尝试两次，一次使用简单的等联结语法，
--        一次使用 INNER JOIN。
SELECT Customers.cust_name, Orders.order_num
FROM Customers,
     Orders
WHERE Customers.cust_id = Orders.cust_id;
-- 使用 INNER JOIN
SELECT Customers.cust_name, Orders.order_num
FROM Customers
         INNER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 12.4.2 我们来让上一题变得更有用些。除了返回顾客名称和订单号，添加第
--        三列 OrderTotal，其中包含每个订单的总价。有两种方法可以执行
--        此操作：使用 OrderItems 表的子查询来创建 OrderTotal 列，或者
--        将 OrderItems 表与现有表联结并使用聚合函数。提示：请注意需要
--        使用完全限定列名的地方。
SELECT Customers.cust_name,
       Orders.order_num,
       (SELECT SUM(quantity * item_price)
        FROM OrderItems
        WHERE Orders.order_num = OrderItems.order_num) AS OrderTotal
FROM Customers
         INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
ORDER BY OrderTotal;
-- 方法二
SELECT Customers.cust_name,
       Orders.order_num,
       SUM(OrderItems.quantity * OrderItems.item_price) AS OrderTotal
FROM Customers,
     Orders,
     OrderItems
WHERE Customers.cust_id = Orders.cust_id
  AND Orders.order_num = OrderItems.order_num
GROUP BY Customers.cust_name, Orders.order_num
ORDER BY OrderTotal;

-- 12.4.3 我们重新看一下第 11 课的挑战题 2。编写 SQL 语句，检索订购产品
--        BR01 的日期，这一次使用联结和简单的等联结语法。输出应该与第
--        11 课的输出相同。
SELECt cust_id, order_date
FROM OrderItems
INNER JOIN Orders on OrderItems.order_num = Orders.order_num
WHERE prod_id = 'BR01'
ORDER BY order_date;

-- 12.4.4 很有趣，我们再试一次。重新创建为第 11 课挑战题 3 编写的 SQL 语
--        句，这次使用 ANSI 的 INNER JOIN 语法。在之前编写的代码中使用
--        了两个嵌套的子查询。要重新创建它，需要两个 INNER JOIN 语句，
--        每个语句的格式类似于本课讲到的 INNER JOIN 示例，而且不要忘记
--        WHERE 子句可以通过 prod_id 进行过滤。
SELECT cust_email
FROM Customers
INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
INNER JOIN OrderItems ON OrderItems.order_num = Orders.order_num
WHERE OrderItems.prod_id = 'BR01';

-- 12.4.5 再让事情变得更加有趣些，我们将混合使用联结、聚合函数和分组。
--        准备好了吗？回到第 10 课，当时的挑战是要求查找值等于或大于 1000
--        的所有订单号。这些结果很有用，但更有用的是订单数量至少达到
--        这个数的顾客名称。因此，编写 SQL 语句，使用联结从 Customers
--        表返回顾客名称（cust_name），并从 OrderItems 表返回所有订单的
--        总价。
--        提示：要联结这些表，还需要包括 Orders 表（因为 Customers 表
--        与 OrderItems 表不直接相关，Customers 表与 Orders 表相关，而
--        Orders 表与 OrderItems 表相关）。不要忘记 GROUP BY 和 HAVING，
--        并按顾客名称对结果进行排序。你可以使用简单的等联结或 ANSI 的
--        INNER JOIN 语法。或者，如果你很勇敢，请尝试使用两种方式编写。
SELECT cust_name, SUM(quantity * item_price)
FROM Customers, Orders, OrderItems
WHERE Customers.cust_id = Orders.cust_id
    AND Orders.order_num = OrderItems.order_num
GROUP BY OrderItems.order_num
HAVING SUM(quantity * item_price) > 1000;
-- 使用 INNER JOIN 的方法做
SELECT cust_name, SUM(quantity * item_price)
FROM Customers
INNER JOIN Orders ON Customers.cust_id = Orders.cust_id
INNER JOIN OrderItems ON Orders.order_num = OrderItems.order_num
GROUP BY OrderItems.order_num
HAVING SUM(quantity * item_price) > 1000;
