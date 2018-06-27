
CREATE DATABASE goods_mamagement CHARACTER SET utf8 COLLATE utf8_general_ci;
use goods_mamagement;
SET time_zone='+7:00';
create table user(
`code` varchar(20),
`username` varchar(50) unique,
`password` varchar(100),
`nameDispay` varchar(100) null,
`linkAvatar` varchar(100) null,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
primary key (`code`)
);

insert into user(`code`,`username`,`password`,`linkAvatar`) values ('001','admin','d033e22ae348aeb5660fc2140aec35850c4da997','/assets/avatar.png');

SET time_zone='+7:00';
SELECT *FROM user LIMIT 0,100;
SELECT *FROM user ORDER BY createAt DESC LIMIT 0,10;
#truncate table user;
#drop table user;

create table token(
`code` varchar(5000),
`userCode` varchar(20),
foreign key(`userCode`) references user(`code`) ON DELETE CASCADE
);

select *from token;
truncate table token;
#drop table token;

create table file_upload(
`nameImg` varchar(100) not null unique,
`linkImg` varchar(300) not null
);

select *from file_upload;
create table categories(
`code` varchar(20) not null,
`name` varchar(100) not null,
`parent` varchar(100) null,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
primary key(`code`),
foreign key (`parent`) references categories(`code`)  ON DELETE CASCADE
);

INSERT INTO `categories` (`code`, `name`) VALUES ('1', 'Vàng');
INSERT INTO `categories` (`code`, `name`) VALUES ('2', 'Bạc');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('3', 'Lắc Tay Vàng', '1');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('4', 'Lắc Tay Bạc', '2');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('5', 'Nhẫn Vàng', '1');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('6', 'Lắc Tay Vàng 1 chỉ', '3');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('7', 'Lắc Tay Bạc 2 chỉ', '4');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('8', 'Nhẫn Vàng 3 chỉ', '5');
INSERT INTO `categories` (`code`, `name`, `parent`) VALUES ('9', 'Nhẫn Vàng 2 chỉ', '3');

select *from categories as ca1 inner join categories;
select *from categories;
INSERT INTO table (id, name, age) VALUES(1, "A", 19) ON DUPLICATE KEY UPDATE    
name="A", age=19
#drop table categories;

create table product(
`code` varchar(20) not null,
`name` varchar(500) not null,
`weigh` double,
`price` double,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`categoryCode` varchar(20) not null,
primary key(`code`),
foreign key(`categoryCode`) references categories(`code`)  ON DELETE CASCADE
);

insert into product(`code`,`name`,`weigh`,`price`,`categoryCode`) values('001','Lắc tay 1 chỉ',1.2,19999999.9,'2'),('002','Nhẫn 2 chỉ',2.4,39999999.9,'2'),('003','Lắc tay 1 chỉ',1.2,999999.9,'1');
select *from product;
select *from product join categories where product.categoryCode = categories.code;
select *from product where categoryCode in (select `code` from categories where `code` = '0002');
#drop table product;

SELECT * FROM product inner join categories on product.categoryCode = categories.code;
create table provider(
`code` varchar(20) not null,
`name` varchar(100) not null,
primary key(`code`)
);


SELECT pro.code,pro.name,pro.weigh,pro.price,pro.createAt,pro.updateAt,pro.categoryCode,cat.name AS category FROM product AS pro INNER JOIN categories AS cat ON pro.categoryCode = cat.code WHERE pro.code = '1';

insert into provider values('001','Hà Nội'),('002','TP Hồ Chí Minh');
select *from provider;
#drop table provider;

create table importOrder(
`code` varchar(20) not null,
`time` date,
`quantity` double,
`totalWeigh` double,
`totalValue` double,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`providerCode` varchar(20),
`productCode` varchar(20),
primary key(`code`),
foreign key(`providerCode`) references provider(`code`)  ON DELETE CASCADE,
foreign key(`productCode`) references product(`code`)  ON DELETE CASCADE
);
 
insert into importOrder(`code`,`time`,`quantity`,`totalWeigh`,`totalValue`,`providerCode`,`productCode`) values ('001','2017-11-11',220000,2.4,6666666.6,'001','002'), ('002','2017-11-11',220000,2.4,6666666.6,'002','002');
select *from importOrder;
#truncate table importOrder;
#drop table importOrder;

create table exportOrder(
`code` varchar(20) not null,
`time` date,
`quantity` double,
`totalWeigh` double,
`totalValue` double,
`customerName` varchar(200),
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`customerAddress` varchar(1000),
`productCode` varchar(20),
primary key(`code`),
foreign key(`productCode`) references product(`code`)  ON DELETE CASCADE
);

insert into exportOrder(`code`,`time`,`quantity`,`totalWeigh`,`totalValue` ,`customerName`,`customerAddress`,`productCode`) values ('001','2017-11-11',220000,2.4,6666666.6,'Đỗ Đông Lộc','Phùng Khoang - Hà Đông','001'), ('002','2017-11-11',220000,2.4,6666666.6,'Đỗ Đông Đức','Phùng Khoang - Hà Đông','002');
select *from exportOrder;
#truncate table exportOrder;
#drop table exportOrder;

#hàng tồn kho
create table inventory(
`code` varchar(100),
`batchTime` date,
`totalQuantity` double,
`totalWeigh` double,
`totalValue` double,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`productCode` varchar(100),
primary key(`code`),
foreign key(`productCode`) references product(`code`)  ON DELETE CASCADE
);

INSERT INTO inventory(`code`,`batchTime`,`totalQuantity`,`totalWeigh`,`totalValue`,`productCode`) VALUES ('001', '2017-12-12', 111111, 11111, 111111, '001'),('002', '2017-12-14', 22222, 2222, 22222, '002');

select *from inventory;
#truncate table inventory;
#drop table inventory;

#doanh thu
create table revenue(
`code` varchar(100),
`batchTime` date,
`totalQuantity` double,
`totalWeigh` double,
`cost` double,
`price` double,
`income` double,
`createAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
`updateAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
`productCode` varchar(100),
primary key(`code`),
foreign key(`productCode`) references product(`code`)  ON DELETE CASCADE
);

INSERT INTO revenue(`code`,`batchTime`,`totalQuantity`,`totalWeigh`,`cost`,`price`,`income`,`productCode`) VALUES ('001', '2017-12-12', 111111, 11111, 111111,111,111111, '001'),('002', '2017-12-15', 22222, 22222, 2222,2222,222, '001');

select *from revenue;
#truncate table revenue;
#drop table revenue;

#drop database goods_mamagement;