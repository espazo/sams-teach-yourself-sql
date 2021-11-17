-- 这一课介绍如何利用 UPDATE 和 DELETE 语句进一步操作表数据。

-- 16.1 更新数据
-- 有两种使用 UPDATE的方式：
-- 1，更新表中的特定行；
-- 2，更新表中的所有行。
--
-- 基本的 UPDATE 语句由三部分组成，分别是：
-- 1，要更新的表；
-- 2，列名和它们的新值；
-- 3，确定要更新哪些行的过滤条件。
UPDATE Customers
SET cust_email = 'kim@thetoystore.com'
WHERE cust_id = 1000000005;
-- 更新多个列
UPDATE Customers
SET cust_contact = 'Sam Roberts',
    cust_email   = 'sam@toyland.com'
WHERE cust_id = 1000000006;
-- 要删除某个列的值，可设置它为 NULL（假如表定义允许 NULL 值）。
UPDATE Customers
SET cust_email = NULL
WHERE cust_id = 1000000005;

-- 16.2 删除数据
-- 从一个表中删除（去掉）数据，使用 DELETE 语句。有两种使用 DELETE 的方式：
-- 1，从表中删除特定的行；
-- 2，从表中删除所有行。
DELETE
FROM Customers
WHERE cust_id = 1000000006;
--
-- 更快的删除
--
-- 如果想从表中删除所有行，不要使用 DELETE。可使用 TRUNCATE TABLE
-- 语句，它完成相同的工作，而速度更快（因为不记录数据的变动）。

-- 16.3 更新和删除的指导原则
-- 下面是许多 SQL 程序员使用 UPDATE 或 DELETE 时所遵循的重要原则。
-- 1，除非确实打算更新和删除每一行，否则绝对不要使用不带 WHERE 子句
--    的 UPDATE 或 DELETE 语句。
-- 2，保证每个表都有主键（如果忘记这个内容，请参阅第 12 课），尽可能
--    像 WHERE 子句那样使用它（可以指定各主键、多个值或值的范围）。
-- 3，在 UPDATE 或 DELETE 语句使用 WHERE 子句前，应该先用 SELECT 进
--    行测试，保证它过滤的是正确的记录，以防编写的 WHERE 子句不正确。
-- 4，使用强制实施引用完整性的数据库（关于这个内容，请参阅第 12 课），
--    这样 DBMS 将不允许删除其数据与其他表相关联的行。
-- 5，有的 DBMS 允许数据库管理员施加约束，防止执行不带 WHERE 子句
--    的 UPDATE 或 DELETE 语句。如果所采用的 DBMS 支持这个特性，应
--    该使用它。

-- 16.4 小结
-- 这一课讲述了如何使用 UPDATE 和 DELETE 语句处理表中的数据。我们学
-- 习了这些语句的语法，知道了它们可能存在的危险，了解了为什么 WHERE
-- 子句对 UPDATE 和 DELETE 语句很重要，还学习了为保证数据安全而应该
-- 遵循的一些指导原则。

-- 16.5 挑战题
-- 16.5.1 美国各州的缩写应始终用大写。编写 SQL语句来更新所有美国地址，包
--        括供应商状态（Vendors 表中的 vend_state）和顾客状态（Customers
--        表中的 cust_state），使它们均为大写。
UPDATE Vendors
SET vend_city  = UPPER(vend_city),
    vend_state = UPPER(vend_state);

UPDATE Customers
SET cust_state = UPPER(cust_state);

-- 16.5.2 第 15 课的挑战题 1 要求你将自己添加到 Customers 表中。现在请删除
--        自己。确保使用 WHERE 子句（在 DELETE 中使用它之前，先用 SELECT
--        对其进行测试），否则你会删除所有顾客！
DELETE
FROM Customers
WHERE cust_name = 'John';
