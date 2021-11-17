-- 这一课将介绍什么是视图，它们怎样工作，何时使用它们；还将讲述如
-- 何利用视图简化前几课中执行的某些 SQL 操作。

-- 18.1 视图
-- 视图是虚拟的表。与包含数据的表不一样，视图只包含使用时动态检索
-- 数据的查询。

-- 18.1.1 为什么使用视图
-- 1，我们已经看到了视图应用的一个例子。下面是视图的一些常见应用。
-- 2，重用 SQL 语句。
-- 3，简化复杂的 SQL 操作。在编写查询后，可以方便地重用它而不必知道
--    其基本查询细节。
-- 4，使用表的一部分而不是整个表。
-- 5，保护数据。可以授予用户访问表的特定部分的权限，而不是整个表的
--    访问权限。
-- 6，更改数据格式和表示。视图可返回与底层表的表示和格式不同的数据。
--
-- 性能问题
-- 因为视图不包含数据，所以每次使用视图时，都必须处理查询执行时
-- 需要的所有检索。如果你用多个联结和过滤创建了复杂的视图或者嵌
-- 套了视图，性能可能会下降得很厉害。因此，在部署使用了大量视图
-- 的应用前，应该进行测试。

-- 18.1.2 视图的规则和限制
-- 下面是关于视图创建和使用的一些最常见的规则和限制。
-- 1，与表一样，视图必须唯一命名（不能给视图取与别的视图或表相同的
--    名字）。
-- 2，对于可以创建的视图数目没有限制。
-- 3，创建视图，必须具有足够的访问权限。这些权限通常由数据库管理人
--    员授予。
-- 4，视图可以嵌套，即可以利用从其他视图中检索数据的查询来构造视图。
--    所允许的嵌套层数在不同的 DBMS中有所不同（嵌套视图可能会严重降
--    低查询的性能，因此在产品环境中使用之前，应该对其进行全面测试）
-- 5，许多 DBMS 禁止在视图查询中使用 ORDER BY 子句。
-- 6，有些 DBMS 要求对返回的所有列进行命名，如果列是计算字段，则需
--    要使用别名（关于列别名的更多信息，请参阅第 7 课）。
-- 7，视图不能索引，也不能有关联的触发器或默认值。
-- 8，有些 DBMS 把视图作为只读的查询，这表示可以从视图检索数据，但
--    不能将数据写回底层表。详情请参阅具体的 DBMS 文档。
-- 9，有些 DBMS 允许创建这样的视图，它不能进行导致行不再属于视图的
--    插入或更新。例如有一个视图，只检索带有电子邮件地址的顾客。
--    如果更新某个顾客，删除他的电子邮件地址，将使该顾客不再属于
--    视图。这是默认行为，而且是允许的，但有的 DBMS 可能会防止这种
--    情况发生。

-- 18.2 创建视图
-- 视图用 CREATE VIEW 语句来创建。与 CREATE TABLE 一样，CREATE VIEW
-- 只能用于创建不存在的视图。
--
-- 视图重命名
-- 删除视图，可以使用 DROP 语句，其语法为 DROP VIEW viewname;。
-- 覆盖（或更新）视图，必须先删除它，然后再重新创建。

-- 18.2.1 利用视图简化复杂联结
CREATE VIEW ProductCustomers AS
SELECT cust_name, cust_contact, prod_id
FROM Customers,
     Orders,
     OrderItems
WHERE Customers.cust_id = Orders.cust_id
  AND OrderItems.order_num = Orders.order_num;
-- 检索订购了产品 RGAN01 的顾客，可如下进行：
SELECT cust_name, cust_contact
FROM ProductCustomers
WHERE prod_id = 'RGAN01';

-- 18.2.2 用视图重新格式化检索出的数据
-- 如前所述，视图的另一常见用途是重新格式化检索出的数据。下面的
-- SELECT 语句（来自第 7 课）在单个组合计算列中返回供应商名和位置：
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')')
           AS vend_title
FROM Vendors
ORDER BY vend_name;
-- 使用视图创建
CREATE VIEW VendorLocations AS
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')')
           AS vend_title
FROM Vendors;
-- 可以简化查询
SELECT *
FROM VendorLocations;

-- 18.2.3 用视图过滤不想要的数据
-- 视图对于应用普通的 WHERE 子句也很有用。例如，可以定义 Customer-
-- EMailList 视图，过滤没有电子邮件地址的顾客。为此，可使用下面的
-- 语句：
CREATE VIEW CustomerEmailList AS
SELECT cust_id, cust_name, cust_email
FROM Customers
WHERE cust_email IS NOT NULL;
-- 使用上面视图
SELECT *
FROM CustomerEmailList;

-- 18.2.4 使用视图与计算字段
SELECT prod_id,
       quantity,
       item_price,
       quantity * item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;
-- 转化为一个视图
CREATE VIEW OrderItemsExpanded AS
SELECT order_num,
       prod_id,
       quantity,
       item_price,
       quantity * item_price AS expanded_price
FROM OrderItems;
-- 使用上面视图
SELECT *
FROM OrderItemsExpanded
WHERE order_num = 20008;

-- 18.3 小结
-- 视图为虚拟的表。它们包含的不是数据而是根据需要检索数据的查询。
-- 视图提供了一种封装 SELECT 语句的层次，可用来简化数据处理，重新
-- 格式化或保护基础数据

-- 18.4 挑战题
-- 18.4.1 创建一个名为 CustomersWithOrders 的视图，其中包含 Customers
--        表中的所有列，但仅仅是那些已下订单的列。提示：可以在 Orders
--        表上使用 JOIN 来仅仅过滤所需的顾客，然后使用 SELECT 来确保拥
--        有正确的数据。
CREATE VIEW CustomersWithOrders AS
SELECT Customers.*
FROM Customers
         INNER JOIN Orders ON Customers.cust_id = Orders.cust_id;

-- 18.5 下面的 SQL 语句有问题吗？（尝试在不运行的情况下指出。）
# CREATE VIEW OrderItemsExpanded AS
# SELECT order_num,
#        prod_id,
#        quantity,
#        item_price,
#        quantity * item_price AS expanded_price
# FROM OrderItems
# ORDER BY order_num;
-- 有问题：视图中不允许使用 ORDER BY
