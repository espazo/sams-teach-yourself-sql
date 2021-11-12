-- 这一课介绍什么是计算字段，如何创建计算字段，以及如何从应用程序
-- 中使用别名引用它们。

-- 7.1 计算字段
-- 字段（field）
-- 基本上与列（column）的意思相同，经常互换使用，不过数据库列一
-- 般称为列，而字段这个术语通常在计算字段这种场合下使用。

-- 7.2 拼接字段
-- 拼接（concatenate）将值联结到一起（将一个值附加到另一个值）构成单个值
SELECT CONCAT(vend_name, ' (', vend_country, ')')
FROM Vendors
ORDER BY vend_name;
-- 可以使用 RTRIM() 来去除右边的空格
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')')
FROM Vendors
ORDER BY vend_name;
-- 别名（alias）使用 AS 关键字赋予，也叫导出列（derived column）
SELECT CONCAT(RTRIM(vend_name), ' (', RTRIM(vend_country), ')') AS vend_title
FROM Vendors
ORDER BY vend_name;

-- 7.3 执行算数运算
SELECT prod_id, quantity, item_price
FROM OrderItems
WHERE order_num = 20008;
-- 汇总物品的价格（单价乘以订购数量）
SELECT prod_id, quantity, item_price, quantity * item_price AS expanded_price
FROM OrderItems
WHERE order_num = 20008;
-- 获取当前日期
SELECT Curdate();

-- 7.5 挑战题
-- 7.5.1 别名的常见用法是在检索出的结果中重命名表的列字段（为了符合特
--       定的报表要求或客户需求）。编写 SQL 语句，从 Vendors 表中检索
--       vend_id、vend_name、vend_address 和 vend_city，将 vend_name
--       重命名为 vname，将 vend_city 重命名为 vcity，将 vend_address
--       重命名为 vaddress。按供应商名称对结果进行排序（可以使用原始
--       名称或新的名称）
SELECT vend_id, vend_name AS vname, vend_address AS vaddress, vend_city AS vcity
FROM Vendors
ORDER BY vend_name;

-- 7.5.2 我们的示例商店正在进行打折促销，所有产品均降价 10%。编写 SQL
--       语句，从 Products 表中返回 prod_id、prod_price 和 sale_price。
--       sale_price 是一个包含促销价格的计算字段。提示：可以乘以 0.9，
--       得到原价的 90%（即 10%的折扣）。
SELECT prod_id, prod_price, prod_price * 0.9 AS sale_price
FROM Products;
