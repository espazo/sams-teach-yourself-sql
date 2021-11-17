-- 这一课介绍如何利用 SQL 的 INSERT 语句将数据插入表中。

-- 15.1 数据插入
-- 插入有几种方式：
-- 1，插入完整的行；
-- 2，插入行的一部分；
-- 3，插入某些查询的结果。

-- 15.1.1 插入完整的行
INSERT INTO Customers
VALUES (1000000006,
        'Toy Land',
        '123 Any Street',
        'New York',
        'NY',
        '11111',
        'USA',
        NULL,
        NULL);
-- 更安全的 INSERT 语句：表名后的括号里明确给出了列名
INSERT INTO Customers(cust_id,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country,
                      cust_contact,
                      cust_email)
VALUES (1000000006,
        'Toy Land',
        '123 Any Street',
        'New York',
        'NY',
        '11111',
        'USA',
        NULL,
        NULL);
-- 以一种不同的次序
-- 填充。因为给出了列名，所以插入结果仍然正确：
INSERT INTO Customers(cust_id,
                      cust_contact,
                      cust_email,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip)
VALUES (1000000006,
        NULL,
        NULL,
        'Toy Land',
        '123 Any Street',
        'New York',
        'NY',
        '11111');

-- 15.1.2 插入部分的行
-- 正如所述，使用 INSERT 的推荐方法是明确给出表的列名。使用这种语
-- 法，还可以省略列，这表示可以只给某些列提供值，给其他列不提供值。
INSERT INTO Customers(cust_id,
                      cust_name,
                      cust_address,
                      cust_city,
                      cust_state,
                      cust_zip,
                      cust_country)
VALUES (1000000006,
        'Toy Land',
        '123 Any Street',
        'New York',
        'NY',
        '11111',
        'USA');
-- 省略的列必须满足以下某个条件。
-- 1，该列定义为允许 NULL 值（无值或空值）。
-- 2，在表定义中给出默认值。这表示如果不给出值，将使用默认值。

-- 15.1.3 插入检索出的数据
# INSERT INTO Customers(cust_id,
#                       cust_contact,
#                       cust_email,
#                       cust_name,
#                       cust_address,
#                       cust_city,
#                       cust_state,
#                       cust_zip,
#                       cust_country)
# SELECT cust_id,
#        cust_contact,
#        cust_email,
#        cust_name,
#        cust_address,
#        cust_city,
#        cust_state,
#        cust_zip,
#        cust_country
# FROM CustNew;

-- 15.2 从一个表复制到另一个表
CREATE TABLE CustCopy AS
SELECT *
FROM Customers;
-- 如果是 SQL Server，可以这么写：
# SELECT * INTO CustCopy FROM Customers;

-- 15.3 小结
-- 这一课介绍如何将行插入到数据库表中。我们学习了使用 INSERT 的几
-- 种方法，为什么要明确使用列名，如何用 INSERT SELECT 从其他表中导
-- 入行，如何用 SELECT INTO 将行导出到一个新表。下一课将讲述如何使
-- 用 UPDATE 和 DELETE 进一步操作表数据。

-- 15.4 挑战题
-- 15.4.1 使用 INSERT 和指定的列，将你自己添加到 Customers 表中。明确列
--        出要添加哪几列，且仅需列出你需要的列。
INSERT INTO Customers(cust_id, cust_name)
VALUES ('1000000007', 'John');

-- 15.4.2 备份 Orders 表和 OrderItems 表。
CREATE TABLE OrdersCopy
SELECT *
FROM Orders;

CREATE TABLE OrderItemsCopy
SELECT *
FROM OrderItems;
