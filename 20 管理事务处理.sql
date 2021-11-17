-- 这一课介绍什么是事务处理，如何利用 COMMIT 和 ROLLBACK 语句管理事
-- 务处理。

-- 20.1 事务处理
-- 使用事务处理（transaction processing），通过确保成批的 SQL 操作要么
-- 完全执行，要么完全不执行，来维护数据库的完整性。
--
-- 下面是关于事务处理需
-- 要知道的几个术语：
-- 1，事务（transaction）指一组 SQL 语句；
-- 2，回退（rollback）指撤销指定 SQL 语句的过程；
-- 3，提交（commit）指将未存储的 SQL 语句结果写入数据库表；
-- 4，保留点（savepoint）指事务处理中设置的临时占位符（placeholder），
--    可以对它发布回退（与回退整个事务处理不同）。
--
-- 可以回退哪些语句？
-- 事务处理用来管理 INSERT、UPDATE 和 DELETE 语句。
-- 不能回退 SELECT语句（回退 SELECT 语句也没有必要），
-- 也不能回退 CREATE 或 DROP 操作。
-- 事务处理中可以使用这些语句，但进行回退时，这些操作也不撤销。

-- 20.2 控制事务处理
# START TRANSACTION

-- 20.2.1 使用 ROLLBACK
DELETE
FROM OrdersCopyRename;
ROLLBACK;

-- 20.2.2 使用 COMMIT
-- 一般的 SQL 语句都是针对数据库表直接执行和编写的。这就是所谓的隐
-- 式提交（implicit commit），即提交（写或保存）操作是自动进行的。
--
-- SQL Server 例子
# BEGIN TRANSACTION
# DELETE OrderItems WHERE order_num = 12345
# DELETE Orders WHERE order_num = 12345
# COMMIT TRANSACTION

-- 20.2.3 使用保留点
-- 在 MariaDB、MySQL 和 Oracle 中
-- 创建占位符，可使用 SAVEPOINT 语句。
# SAVEPOINT delete1;
-- 每个保留点都要取能够标识它的唯一名字，以便在回退时，DBMS 知道
-- 回退到何处。
# ROLLBACK TO delete1;
--
-- 保留点越多越好
-- 可以在 SQL 代码中设置任意多的保留点，越多越好。为什么呢？因为
-- 保留点越多，你就越能灵活地进行回退。

-- 20.3 小结
-- 这一课介绍了事务是必须完整执行的 SQL 语句块。我们学习了如何使用
-- COMMIT 和 ROLLBACK 语句对何时写数据、何时撤销进行明确的管理；还
-- 学习了如何使用保留点，更好地控制回退操作。事务处理是个相当重要
-- 的主题，一课内容无法全部涉及。各种 DBMS 对事务处理的实现不同，
-- 详细内容请参考具体的 DBMS 文档。
