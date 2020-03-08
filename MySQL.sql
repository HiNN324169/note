
--------------------------数据库操作--------------

-- 创建数据库
create database mydatabase;

-- 指定编码级 创建数据库
create database mydatabase2 charset utf8;

-- 显示所有的数据库
show databases;

-- 查看以my开头的数据库
show databases like 'my%';

-- '_': 表示该字符未知;
-- '%': 表示该字符未知 或者 多个字符未知;

-- 显示数据库创建语句(语句被系统加工过)
show create database mydatabase;

-- 选择数据库
use mydatabase;

-- 修改数据字符集
alter database mydatabase charset utf8mb4;

-- 删除数据库
drop database mydatabase2;



--------------------------------配置数据库编码级----------------

--查看数据编码详情
show variables like '%char%';

-- 设置编码(从Mysql 5.5.3 开始，MySQL 开始用 utf8mb4 编码来实现完整的 UTF-8，其中 mb4 表示 most bytes 4，最多占用4个字节。从 8.0 之后，将会在某个版本开始用 utf8mb4 作为默认字符编码。)
-- 设置编码
 set character_set_client = utf8mb4;
 set character_set_connection =utf8mb4;
-- ... 下面都一样
-- character_set_client：客户端请求数据的字符集
-- character_set_connection：从客户端接收到数据，然后传输的字符集
-- character_set_database：默认数据库的字符集，无论默认数据库如何改变，都是这个字符集；如果没有默认数据库，那就使用 character_set_server指定的字符集，这个变量建议由系统自己管理，不要人为定义。
-- character_set_filesystem：把操作系统上的文件名转化成此字符集，即把 character_set_client转换character_set_filesystem， 默认binary是不做任何转换的
-- character_set_results：结果集的字符集
-- character_set_server：数据库服务器的默认字符集
-- character_set_system：存储系统元数据的字符集，总是 utf8，不需要设置


---------------------------------数据表操作--------------------

-- 创建数据表 并 将表挂载到指定数据库
--方案一：
use mydatabase;
create table class(
	name varchar(20)
);

-- 方案二：
create table mydatabase2.class2(
	name varchar(10)
);

-- 表选项：与数据库选项类似
-- Engine：储存引擎，mysql提供的具体储存数据的方式，默认有一个innodb（5.5以前默认是myisam）
-- charset：字符集，只对当前自己表有效（级别比数据库高）
-- Collate：校对集

-- 使用表选项
create table student(
	name varchar(20)
)charset utf8mb4;

-- 复制表结构,将mydatabase中的student表结构复制到 mydatabase2 数据库中。
create table mydatabase2.student2 like mydatabase.student;

-- 查看匹配表
show tables like 'stu%'

-- 查看表结构
desc student;

-- 显示 创建数据表 语句；
show create table student;
-- mysql 中有多种语句结束符
-- ; 与 \g 所表示的效果一样，都是字段在上牌横着，下面对应数据
-- \G 字段在左侧竖着，数据在右侧横着
show create table student\G;

-- 修改表选项（charset、）
alter table student charset utf8mb4;

-- 数据库总数据表名字通常有前缀：去数据库的前两个字母命名
-- 修改表名字
rename table mydatabase.student to my_student;

-- 给学生表增加age字段
alter table my_student add column age int;

-- 增加字段放到第一个字段：first
alter table my_student add id int first;

-- 修改字段名:修改之后 必须重新定义新字段的数据类型
alter table my_student change age nj int;

-- 修改字段类型 例如：varchar(10)--> varchar(20);varchar-->int;
alter table my_student modify name varchar(20);

-- 删除字段
alter table my_student drop nj;

-- 删除表
drop table class

-- 批量删除表
drop table class,sun;


-- -----------------------------插入数据----------
-- 前后数据必须一一对应对应 向表中指定字段 插入数据
insert into my_student(name,age) values('张三','25');

--向表中所有字段插入数据(有几个字段，就得插入几个字段值)
insert into my_student values('','','')


-- -----------------------------查询数据----------
-- 查询所有数据
select * from my_student;

-- 查询指定数据
select * from my_student where name = '李四';


-- -----------------------------删除数据----------
-- 删除指定数据
delete from my_student where name = '张三';

-- 删除指定列
ALTER TABLE '表名' drop column '列名';
 
-- -----------------------------修改数据----------
-- 修改指定数据
update my_student set age = 88 where name = '李四';




-- --------------------------- 列类型（字段类型）---------
-- 整数类型

-- Tinyint
-- 迷你整形，系统采用一个字节来保存的整形：一个字节 = 8 位，最大能表示的数值是（-128~127）

-- Smallint
-- 小整形，系统采用两个字节来保存的整形: 能表示0-65535之间

-- Mediumint
-- 中整形，采用三个字节来保存数据。

-- int
-- 整形（标准整形），采用四个字节来保存数据。

-- Bigint
-- 大整形，采用八个字节来保存数据。

-- 无符号（unsigned）表示：该字段只能为整数。
-- 例如：表示：int_6 字段 取值为非负数（0-255）
alter table my_int add int_6 tinyint unsigned first;

--------------------------------显示长度------------------
-- 显示长度：指数据（整数）在数据显示的时候，到底可以显示多长位。
-- Tinyint(3) ：表示最长可以显示3位，unsigned 说明只能是整数，0-255 永远不会超多三个长度。
--Tinyint(4)：表示最长可以显示4位，-128~127

-- 显示长度只是代表了数据是否可以达到指定的长度，但是不会自动满足到指定长度：
-- 如果想要数据显示长度的时候，保持最高为(显示长度)，那么还需要给字段增加一个zerofill属性才可以。
-- Zerofill：从左侧开始填充0（左侧不会改变数值大小），所以负数的时候就不能使用zerofill，
-- 一旦使用zerofill 就相当于确定该字段为：unsigned
alter table my_int add int_7 tinyint zerofill first;



------------------------ 主键 primary key 不为空------------------------------
-- 随表增加主键
create table my_pri(
	username varchar(10),
	primary key(username)
)charset utf8; 

create table my_pri2(
	username varchar(10) primary key;
)charset utf8;


-- 创建表之后添加 主键 
alter table my_pri3 add primary key(username);

-- 查看主键
desc my_pri3;

-- 删除主键
alter table my_pri3 drop primary key;


------ 复合主键--- 一张表中存在多个主键  --------
create table my_pri4(
	my_id int,
	username varchar(10),
	primary key(my_id,username)
)charset utf8;


------------------- 自动增长 auto_increment---------
-- 注意：一张表里面 只能有一个字段为自动增长
create table my_auto(
	id int primary key auto_increment,
	name varchar(10) not null
)charset utf8;

-- 修改 auto_increment 
alter table my_auto auto_increment = 10;

-- 删除自增长,修改字段，不要加自动增长的属性
alter table my_auto modify id int;

-- 修改主键 自动增长策略
ALTER TABLE sys_tb_customer_payway MODIFY tb_payway_id INT PRIMARY KEY AUTO_INCREMENT; 

-- 查看自动增长初始变量
show variables like '%auto_increment%';
-- 参数1：auto_increment_increment --> 步长
-- 参数2：auto_increment_offset --> 初始值


-- ------------------ 唯一键 --------------
-- 效果：在不为空的时候 不允许为空
-- 方式一：
create table my_unique1(
	id int primary key auto_increment,
	name varchar(10) not null unique
)charset utf8;

-- 方式二：
create table my_unique2(
	id int primary key auto_increment,
	name varchar(10) not null,
	pwd varchar(10) not null,
	unique key(name)
)charset utf8mb4;

-- 方式三：
create table my_unique3(
	id int primary key auto_increment,
	name varchar(20) not null
)charset utf8mb4;
-- 添加 unique 唯一键
alter table my_unique3 add unique key(name);

-- 查看唯一键
desc my_unique3;

-- 删除唯一键
-- index 关键字：索引，唯一键是索引的一种（提升查询效率）
-- 基本语法：alter table 表名 drop index 唯一键名字;
alter table my_unique3 drop index name;

-- 修改唯一键：先删除 后 添加


------------------------ 高级操作 ---------------------

--------- 新增数据----------
create table tb1(
	id int primary key auto_increment,
	name varchar(10) not null,
	sex varchar(4) not null
)charset utf8mb4;

insert into tb1(name) values('n4'),('n5'),('n6');
insert into tb1(name) values('n1'),('n2'),('n3');


-- 主键冲突  冲突更新
insert into tb1 values('stu001','小婷') on duplicate key update name = '小腿';

-- 主键冲突替换
-- 当主键冲突后，先干掉原来的数据，重新插入数据
replace into tb2 values ('stu001','小腿');

-- -----------------蠕虫复制-----------
-- 一分为二，成倍的增加；充已经有的数据中获取数据，并且将获取到的数据插入到数据表中。
-- 基本语法：
insert into 表名('','') select * 或者 '','' from 表;
create table tb3(
	name varchar(10) not null
);

insert into my_student(name,sex) values('李四','555'),('赵柳','555'),('孩子','555');
-- 进行蠕虫复制
INSERT INTO my_student(NAME,sex) SELECT NAME,sex FROM my_student;


---------------- 更新数据--------
update my_student set name = '李四' where sex = '男' limit 1,3;


-- 重置 主键充初始值开始
turncate my_student;  -- 让主键从1 （默认值）开始。



------- 高级查询-------------------------------
 
 -- 完整的查询指令
 select [select选项] [字段列表] from 数据源 where 条件 group by 分组 having 条件 by 排序 limit 限制;
 
 -- select 选项：系统改如何对待查询得到的结果
 -- All：默认的，表示保存所有的记录
 -- distinct ：去除重复的数据
 
 -- 字段列表：有的时候需要从多张表获取数据，在获取数据的时候，可能存在不同表中有通明的字段，
 -- 需要将同名的字段命名成不同名的：别名 alias
 -- 基本语法：字段名 [as] 别名   --- 最后以别名形式显示
 
 -- from 数据源
 -- from 是为前面查询提供数据：数据源只要是一个符合二维表结构的数据即可
 -- 事例：
 -- 单表数据
 -- >> 基本语法：from 表名;
 
 -- 多表数据
 -- >> 从多张表获取数据，基本语法：from 表1,表2,... 
 select * from tb1,tb2;
 -- 结果：两张表的记录数相乘，字段数拼接
 -- 本质：从第一张表取出一条记录，去拼凑第二张表的所有记录，保留所有结果。
 -- 得到的结果在数学上有一个专业的说法：笛卡尔积，这个结果除了给数据库造成压力
 -- 没有其他意义：应该尽量避免出现笛卡尔积。 
 
 -- -------------- 动态数据-----------------
 -- from 后面跟的数据不是一个实体表，而是一个表中查询出来得到的二维结果表（子查询）
 -- 基本语法：from (select 字段列表 from 表) as 别名;
 
 
 -------------------- where 子句 ---------------------
 -- where 子句：用来从数据表获取数据的时候，然后进行条件筛选。
 -- 数据获取的原理：针对表去对应的磁盘出获取所有的记录（一条条），where 的作用就是拿
 -- 到一条结果就开始进行判断，判断是否符合条件：如果符合就保存下来，如果不符合直接舍弃（不放内存中）
 -- where 是通过运算符进行结果比较来判断数据
 
 ----------------------------------------------- 设置编码---------
 set names gbk;
 
 --------------------- group by ---分组统计------------
 
 
  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  








