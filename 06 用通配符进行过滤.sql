-- 这一课介绍什么是通配符、如何使用通配符，以及怎样使用 LIKE 操作
-- 符进行通配搜索，以便对数据进行复杂过滤。

-- 6.1 LIKE 操作符
-- 通配符（wildcard）用来匹配值的一部分的特殊字符。
-- 搜索模式（search pattern）由字面值、通配符或两者组合构成的搜索条件。
-- 谓词（predicate）
-- 操作符何时不是操作符？答案是，它作为谓词时。从技术上说，LIKE
-- 是谓词而不是操作符。虽然最终的结果是相同的，但应该对此术语有
-- 所了解，以免在 SQL 文献或手册中遇到此术语时不知所云。

-- 6.1.1 百分号（%）通配符
-- %表示任何字符出现任意次数
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE 'Fish%';
-- 通配符可在搜索模式中的任意位置使用，并且可以使用多个通配符。
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '%bean bag%';
-- 通配符也可以放在中间
-- %还能匹配 0 个字符，但是不会匹配 NULL 值
SELECT prod_name
FROM Products
WHERE prod_name LIKE 'F%y';

-- 6.1.2 下划线（_）通配符
-- 只匹配单个字符
SELECT prod_id, prod_name
FROM Products
WHERE prod_name LIKE '__ inch teddy bear';

-- 6.1.3 方括号（[]）通配符
-- 方括号（[]）通配符用来指定一个字符集，它必须匹配指定位置（通配
-- 符的位置）的一个字符。
-- MariaDB 不支持
SELECT cust_contact
FROM Customers
WHERE cust_contact LIKE '[JM]%'
ORDER BY cust_contact;
-- 排除 JM 的用法
SELECT cust_contact
FROM Customers
WHERE cust_contact LIKE '[^JM]%'
ORDER BY cust_contact;
-- 当然使用 NOT 也是可以的
SELECT cust_contact
FROM Customers
WHERE NOT cust_contact LIKE '[JM]%'
ORDER BY cust_contact;

-- 6.2 使用通配符的技巧
-- 6.2.1 不要过度使用通配符。如果其他操作符能达到相同的目的，应该使用其他操作符。
-- 6.2.2 在确实需要使用通配符时，也尽量不要把它们用在搜索模式的开始处。把通配符置于开始处，搜索起来是最慢的。
-- 6.2.3 仔细注意通配符的位置。如果放错地方，可能不会返回想要的数据。

-- 6.4 挑战题
-- 6.4.1 编写 SQL 语句，从 Products 表中检索产品名称（prod_name）和描
--       述（prod_desc），仅返回描述中包含 toy 一词的产品。
SELECT prod_name
FROM Products
WHERE prod_desc LIKE '%toy%';

-- 6.4.2 反过来再来一次。编写 SQL 语句，从 Products 表中检索产品名称
--       （prod_name）和描述（prod_desc），仅返回描述中未出现 toy 一词
--       的产品。这次，按产品名称对结果进行排序。
SELECT prod_name
FROM Products
WHERE prod_desc NOT LIKE '%toy%'
ORDER BY prod_name;

-- 6.4.3 编写 SQL 语句，从 Products 表中检索产品名称（prod_name）和描
--       述（prod_desc），仅返回描述中同时出现 toy 和 carrots 的产品。
--       有好几种方法可以执行此操作，但对于这个挑战题，请使用 AND 和两
--       个 LIKE 比较。
SELECT prod_name, prod_desc
FROM Products
WHERE prod_desc LIKE '%toy%'
  AND prod_desc LIKE '%carrots%';

-- 6.4.4 来个比较棘手的。我没有特别向你展示这个语法，而是想看看你根据
--       目前已学的知识是否可以找到答案。编写 SQL 语句，从 Products 表
--       中检索产品名称（prod_name）和描述（prod_desc），仅返回在描述
--       中以先后顺序同时出现 toy 和 carrots 的产品。提示：只需要用带
--       有三个 % 符号的 LIKE 即可。
SELECT prod_name, prod_desc
FROM Products
WHERE prod_desc LIKE '%toy%carrots%';
