-- 这一课介绍 SQL 所涉及的几个高级数据处理特性：约束、索引和触发器。

-- 22.1 约束
--
-- 虽然可以在插入新行时进行检查（在另一个表上执行 SELECT，以保 证所
-- 有值合法并存在），但最好不要这样做，原因如下。
-- 1，如果在客户端层面上实施数据库完整性规则，则每个客户端都要被迫
--    实施这些规则，一定会有一些客户端不实施这些规则。
-- 2，在执行 UPDATE 和 DELETE 操作时，也必须实施这些规则。
-- 3，执行客户端检查是非常耗时的，而 DBMS 执行这些检查会相对高效。
--
-- 约束（constraint）
-- 管理如何插入或处理数据库数据的规则。
--
-- 大多数约束是在
-- 表定义中定义的，如第 17 课所述，用 CREATE TABLE 或 ALTER TABLE
-- 语句。

-- 22.1.1 主键
-- 表中任意列只要满足以下条件，都可以用于主键。
-- 1，任意两行的主键值都不相同。
-- 2，每行都具有一个主键值（即列中不允许 NULL 值）。
-- 3，包含主键值的列从不修改或更新。（大多数 DBMS 不允许这么做，但
--    如果你使用的 DBMS 允许这样做，好吧，千万别！）
-- 4，主键值不能重用。如果从表中删除某一行，其主键值不分配给新行。
--
-- 一种定义主键的方法是创建它，如下所示。
CREATE TABLE Vendors
(
    vend_id      CHAR(10) NOT NULL PRIMARY KEY,
    vend_name    CHAR(50) NOT NULL,
    vend_address CHAR(50) NULL,
    vend_city    CHAR(50) NULL,
    vend_state   CHAR(5)  NULL,
    vend_zip     CHAR(10) NULL,
    vend_country CHAR(50) NULL
);
-- 给表的 vend_id 列定义添加关键字 PRIMARY KEY，使其成
-- 为主键。
ALTER TABLE Vendors
    ADD CONSTRAINT PRIMARY KEY (vend_id);

-- 22.1.2 外键
-- 使用 REFERENCES 定义外键
CREATE TABLE Orders
(
    order_num  INTEGER  NOT NULL PRIMARY KEY,
    order_date DATETIME NOT NULL,
    cust_id    CHAR(10) NOT NULL REFERENCES customers (cust_id)
);
-- 相同的工作也可以在 ALTER TABLE 语句中用 CONSTRAINT 语法来完成：
ALTER TABLE Orders
    ADD CONSTRAINT FOREIGN KEY (cust_id) REFERENCES customers (cust_id);

-- 22.1.3 唯一约束
--
-- 唯一约束用来保证一列（或一组列）中的数据是唯一的。它们类似于主
-- 键，但存在以下重要区别。
-- 1，表可包含多个唯一约束，但每个表只允许一个主键。
-- 2，唯一约束列可包含 NULL 值。
-- 3，唯一约束列可修改或更新。
-- 4，唯一约束列的值可重复使用。
-- 5，与主键不一样，唯一约束不能用来定义外键。
--
-- 可以通过在社会安全号列上定义 UNIQUE 约束做到。
--
-- 唯一约束的语法类似于其他约束的语法。唯一约束既可以用 UNIQUE 关
-- 键字在表定义中定义，也可以用单独的 CONSTRAINT 定义。

-- 22.1.4 检查约束
-- 检查约束用来保证一列（或一组列）中的数据满足一组指定的条件。检
-- 查约束的常见用途有以下几点。
-- 1，检查最小或最大值。例如，防止 0 个物品的订单（即使 0 是合法的数）。
-- 2，指定范围。例如，保证发货日期大于等于今天的日期，但不超过今天
--    起一年后的日期。
-- 3，只允许特定的值。例如，在性别字段中只允许 M 或 F。
--
-- 下面的例子对 OrderItems 表施加了检查约束，它保证所有物品的数量
-- 大于 0。
CREATE TABLE OrderItems
(
    order_num  INTEGER  NOT NULL,
    order_item INTEGER  NOT NULL,
    prod_id    CHAR(10) NOT NULL,
    quantity   INTEGER  NOT NULL CHECK ( quantity > 0 ),
    item_price DECIMAL  NOT NULL
);
-- 检查名为 gender 的列只包含 M 或 F，可编写如下的 ALTER TABLE 语句：
# ADD CONSTRAINT CHECK (gender LIKE '[MF]')

-- 22.2 索引
-- 在开始创建索引前，应该记住以下内容。
-- 1，索引改善检索操作的性能，但降低了数据插入、修改和删除的性能。
--    在执行这些操作时，DBMS 必须动态地更新索引。
-- 2，索引数据可能要占用大量的存储空间。
-- 3，并非所有数据都适合做索引。取值不多的数据（如州）不如具有更多
--    可能值的数据（如姓或名），能通过索引得到那么多的好处。
-- 4，索引用于数据过滤和数据排序。如果你经常以某种特定的顺序排序数
--    据，则该数据可能适合做索引。
-- 5，可以在索引中定义多个列（例如，州加上城市）。这样的索引仅在以州
--    加城市的顺序排序时有用。如果想按城市排序，则这种索引没有用处。
--
-- 索引用 CREATE INDEX 语句创建（不同 DBMS 创建索引的语句变化很
-- 大）。下面的语句在 Products 表的产品名列上创建一个简单的索引。
CREATE INDEX prod_name_ind
    ON Products (prod_name);
-- 删除索引
DROP INDEX prod_name_ind ON Products;

-- 22.3 触发器
-- 触发器是特殊的存储过程，它在特定的数据库活动发生时自动执行。触发
-- 器可以与特定表上的 INSERT、UPDATE 和 DELETE 操作（或组合）相关联。
--
-- 与存储过程不一样（存储过程只是简单的存储 SQL 语句），触发器与单
-- 个的表相关联。
--
-- 触发器内的代码具有以下数据的访问权：
-- 1，INSERT 操作中的所有新数据；
-- 2，UPDATE 操作中的所有新数据和旧数据；
-- 3，DELETE 操作中删除的数据。
-- 根据所使用的 DBMS的不同，触发器可在特定操作执行之前或之后执行。
--
-- 下面是触发器的一些常见用途。
-- 1，保证数据一致。例如，在 INSERT 或 UPDATE 操作中将所有州名转换
--    为大写。
-- 2，基于某个表的变动在其他表上执行活动。例如，每当更新或删除一行
--    时将审计跟踪记录写入某个日志表。
-- 3，进行额外的验证并根据需要回退数据。例如，保证某个顾客的可用资
--    金不超限定，如果已经超出，则阻塞插入。
-- 4，计算计算列的值或更新时间戳。
--
-- 下面的例子创建一个触发器，它对所有 INSERT 和 UPDATE 操作，将
-- Customers 表中的 cust_state 列转换为大写。
# CREATE TRIGGER customers_state
#     AFTER INSERT OR UPDATE
#     FOR EACH ROW
# BEGIN
# UPDATE Customers
# SET cust_state = UPPER(cust_state)
# WHERE Customers.cust_id = :OLD.cust_id
#     END;
--
-- 提示：约束比触发器更快
-- 一般来说，约束的处理比触发器快，因此在可能的时候，应该尽量使
-- 用约束。

-- 22.4 数据库安全
-- 一般说来，需要保护的操作有：
-- 1，对数据库管理功能（创建表、更改或删除已存在的表等）的访问；
-- 2，对特定数据库或表的访问；
-- 3，访问的类型（只读、对特定列的访问等）；
-- 4，仅通过视图或存储过程对表进行访问；
-- 5，创建多层次的安全措施，从而允许多种基于登录的访问和控制；
-- 6，限制管理用户账号的能力。
--
-- 安全性使用 SQL 的 GRANT 和 REVOKE 语句来管理，不过，大多数 DBMS
-- 提供了交互式的管理实用程序，这些实用程序在内部使用 GRANT 和
-- REVOKE 语句。

-- 22.5 小结
-- 本课讲授如何使用 SQL 的一些高级特性。约束是实施引用完整性的重要
-- 部分，索引可改善数据检索的性能，触发器可以用来执行运行前后的处
-- 理，安全选项可用来管理数据访问。不同的 DBMS 可能会以不同的形式
-- 提供这些特性，更详细的信息请参阅具体的 DBMS 文档。
