-- 这一课介绍什么是函数，DBMS 支持何种函数，以及如何使用这些函数；
-- 还将讲解为什么 SQL 函数的使用可能会带来问题。

-- 8.1 函数
-- 函数带来的问题：与 SQL 语句不一样，SQL 函数不是可移植的。
-- 可移植（portable）所编写的代码可以在多个系统上运行。

-- 8.2 使用函数
-- 1，用于处理文本字符串（如删除或填充值，转换值为大写或小写）的文本函数。
-- 2，用于在数值数据上进行算术操作（如返回绝对值，进行代数运算）的数值函数。
-- 3，用于处理日期和时间值并从这些值中提取特定成分（如返回两个日期之差，检查日期有效性）的日期和时间函数。
-- 4，用于生成美观好懂的输出内容的格式化函数（如用语言形式表达出日期，用货币符号和千分位表示金额）
-- 5，返回 DBMS 正使用的特殊信息（如返回用户登录信息）的系统函数。

-- 8.2.1 文本处理函数
-- 使用 UPPER() 函数将文本转换为大写
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase
FROM Vendors
ORDER BY vend_name;
# LEFT()                   返回字符串左边的字符
# LENGTH()                 返回字符串的长度
# LOWER()                  将字符串转换成小写
# LTRIM()                  去掉字符串左边的空格
# RIGHT()                  返回字符串右边的字符
# RTRIM()                  去掉字符串右边的空格
# SUBSTR() 或 SUBSTRING()   提取字符串的组成部分
# SOUNDEX()                返回字符串的 SOUNDEX 值
# UPPER()                  将字符串转换成大写
-- 用 SOUNDEX()函数进行搜索，它匹配所有发音类似于 Michael Green 的联系名
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green');

-- 8.2.2 日期和时间处理函数
-- 使用 EXTRACT() 函数提取日期的其中一部分
SELECT order_num
FROM Orders
WHERE EXTRACT(year FROM order_date) = 2020;
-- MariaDB 可以使用 Year() 来完成相同的操作
SELECT order_num
FROM Orders
WHERE YEAR(order_date) = 2020;

-- 8.2.3 数值处理函数
# ABS() 返回一个数的绝对值
# COS() 返回一个角度的余弦
# EXP() 返回一个数的指数值
# PI() 返回圆周率 π 的值
# SIN() 返回一个角度的正弦
# SQRT() 返回一个数的平方根
# TAN() 返回一个角度的正切

-- 8.4 挑战题
-- 8.4.1 我们的商店已经上线了，正在创建顾客账户。所有用户都需要登录名，
--       默认登录名是其名称和所在城市的组合。编写 SQL 语句，返回顾客 ID
--       （cust_id）、顾客名称（customer_name）和登录名（user_login），
--       其中登录名全部为大写字母，并由顾客联系人的前两个字符（cust_
--       contact）和其所在城市的前三个字符（cust_city）组成。例如，
--       我的登录名是 BEOAK（Ben Forta，居住在 Oak Park）。提示：需要使用
--       函数、拼接和别名。
SELECT cust_id AS ID, cust_name, CONCAT(SUBSTR(UPPER(cust_name), 1, 2), SUBSTR(UPPER(cust_city), 1, 3)) AS user_login
FROM Customers;

-- 8.4.2 编写 SQL 语句，返回 2020 年 1 月的所有订单的订单号（order_num）
--       和订单日期（order_date），并按订单日期排序。你应该能够根据目
--       前已学的知识来解决此问题，但也可以开卷查阅 DBMS 文档。
SELECT order_num, order_date
FROM Orders
WHERE YEAR(order_date) = 2020
  AND MONTH(order_date) = 1
ORDER BY order_date;
