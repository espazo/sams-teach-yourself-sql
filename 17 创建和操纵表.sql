-- 这一课讲授创建、更改和删除表的基本知识。

-- 17.1 创建表
-- 一般有两种创建表的方法：
-- 1，多数 DBMS 都具有交互式创建和管理数据库表的工具；
-- 2，表也可以直接用 SQL 语句操纵。

-- 17.1.1 表创建基础
-- 利用 CREATE TABLE 创建表，必须给出下列信息：
-- 1，新表的名字，在关键字 CREATE TABLE 之后给出；
-- 2，表列的名字和定义，用逗号分隔；
-- 3，有的 DBMS 还要求指定表的位置
CREATE TABLE Products
(
    prod_id    CHAR(10)      NOT NULL,
    vend_id    CHAR(10)      NOT NULL,
    prod_name  CHAR(254)     NOT NULL,
    prod_price DECIMAL(8, 2) NOT NULL,
    prod_desc  VARCHAR(1000) NULL
);

-- 17.1.2 使用 NULL 值
CREATE TABLE Orders
(
    order_num  INTEGER  NOT NULL,
    order_date DATETIME NOT NULL,
    cust_id    CHAR(10) NOT NULL
);
-- 下一个例子将创建混合了 NULL 和 NOT NULL 列的表：
CREATE TABLE Vendors
(
    vend_id      CHAR(10) NOT NULL,
    vend_name    CHAR(50) NOT NULL,
    vend_address CHAR(50),
    vend_city    CHAR(50),
    vend_state   CHAR(5),
    vend_zip     CHAR(10),
    vend_country CHAR(50)
);

-- 17.1.3 指定默认值
-- SQL 允许指定默认值，在插入行时如果不给出值，DBMS 将自动采用默
-- 认值。默认值在 CREATE TABLE 语句的列定义中用关键字 DEFAULT 指定。
CREATE TABLE OrderItems
(
    order_num  INTEGER       NOT NULL,
    order_item INTEGER       NOT NULL,
    prod_id    CHAR(10)      NOT NULL,
    quantity   INTEGER       NOT NULL DEFAULT 1,
    item_price DECIMAL(8, 2) NOT NULL
);
-- 默认值经常用于日期或时间戳列。例如，通过指定引用系统日期的函数
-- 或变量，将系统日期用作默认日期。
-- 1，MySQL 用户指定 DEFAULT CURRENT_DATE()，
-- 2，Oracle 用户指定 DEFAULT SYSDATE，
-- 3， 而 SQL Server 用户指定 DEFAULT GETDATE()。

-- 17.2 更新表
-- 以下是使用 ALTER TABLE 时需要考虑的事情。
-- 1，理想情况下，不要在表中包含数据时对其进行更新。应该在表的设计
--    过程中充分考虑未来可能的需求，避免今后对表的结构做大改动。
-- 2，所有的 DBMS 都允许给现有的表增加列，不过对所增加列的数据类型
--   （以及 NULL 和 DEFAULT 的使用）有所限制。
-- 3，许多 DBMS 不允许删除或更改表中的列。
-- 4，多数 DBMS 允许重新命名表中的列。
-- 5，许多 DBMS 限制对已经填有数据的列进行更改，对未填有数据的列几
--    乎没有限制。
--
-- 使用 ALTER TABLE 更改表结构，必须给出下面的信息：
-- 1，在 ALTER TABLE 之后给出要更改的表名（该表必须存在，否则将出错）；
-- 2，列出要做哪些更改。
ALTER TABLE Vendors
    ADD vend_phone CHAR(20);
--
ALTER TABLE Vendors
    DROP COLUMN vend_phone;
--
-- 复杂的表结构更改一般需要手动删除过程，它涉及以下步骤：
-- 1，用新的列布局创建一个新表；
-- 2，使用 INSERT SELECT 语句（关于这条语句的详细介绍，请参阅第 15
--    课）从旧表复制数据到新表。有必要的话，可以使用转换函数和计算
--    字段；
-- 3，检验包含所需数据的新表；
-- 4，重命名旧表（如果确定，可以删除它）；
-- 5，用旧表原来的名字重命名新表；
-- 6，根据需要，重新创建触发器、存储过程、索引和外键。

-- 17.3 删除表
-- 删除表（删除整个表而不是其内容）非常简单，使用 DROP TABLE 语句
-- 即可：
DROP TABLE CustCopy;

-- 17.4 重命名表
RENAME TABLE OrdersCopy TO OrdersCopyRename;

-- 17.5 小结
-- 这一课介绍了几条新的 SQL 语句。CREATE TABLE 用来创建新表，ALTER
-- TABLE 用来更改表列（或其他诸如约束或索引等对象），而 DROP TABLE
-- 用来完整地删除一个表。这些语句必须小心使用，并且应该在备份后使
-- 用。由于这些语句的语法在不同的 DBMS 中有所不同，所以更详细的信
-- 息请参阅相应的 DBMS 文档。

-- 17.6 挑战题
-- 17.6.1 在 Vendors 表中添加一个网站列（vend_web）。你需要一个足以容纳
--         URL 的大文本字段。
ALTER TABLE Vendors
    ADD ven_web VARCHAR(128);

-- 17.6.2 使用 UPDATE 语句更新 Vendor 记录，以便加入网站（你可以编造任
--         何地址）
UPDATE Vendors
SET ven_web = 'https://shredder.ink/';
