DROP DATABASE IF EXISTS `air_booking`;
CREATE DATABASE IF NOT EXISTS `air_booking`;
USE `air_booking`;

select *
from `air_seat` s
         inner join `operate_user` u on s.operates_id = u.operate_id
         inner join `cabin_type` t on s.cabins_id = t.cabin_id
         inner join `airline_company` c on s.airlines_id = c.airline_id
         inner join `flight_records` f on s.flights_id = f.flight_id
where s.seat_status = 0
  and s.flights_id = 13;

#用户表
DROP TABLE IF EXISTS `operate_user`;
CREATE TABLE IF NOT EXISTS `operate_user`
(
    `operate_id`       INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户编号',
    `operate_tel`      VARCHAR(11) NOT NULL COMMENT '用户电话',
    `operate_surname`  CHAR(2)     NOT NULL COMMENT '用户姓',
    `operate_username` VARCHAR(20) NOT NULL COMMENT '用户名',
    `operate_password` VARCHAR(16) NOT NULL COMMENT '用户密码',
    `operate_role`     INT         NOT NULL DEFAULT 1 COMMENT '用户权限',#1普通用户 2超级管理员
    `operate_member`   INT         NOT NULL DEFAULT 1 COMMENT '用户是否是会员',#1普通用户 2会员用户
    `operate_status`   INT         NOT NULL DEFAULT 1 COMMENT '用户状态',# 1可用 2不可用
    `operate_update`   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '用户默认创建时间'
);

insert into `operate_user` values (0,'17312300720','A','admin','admin',1,1,1,default);


#用户证件表
DROP TABLE IF EXISTS `certificate_info`;
CREATE TABLE IF NOT EXISTS `certificate_info`
(
    `cer_id`   INT PRIMARY KEY AUTO_INCREMENT COMMENT '证件ID',
    `cer_name` VARCHAR(50) NOT NULL COMMENT '证件名称'
);

INSERT INTO `certificate_info`(CER_ID, CER_NAME)
VALUES (0, '护照'),
       (0, '军官证'),
       (0, '身份证');

#用户信息表
DROP TABLE IF EXISTS `user_info`;
CREATE TABLE IF NOT EXISTS `user_info`
(
    `user_id`    INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户信息ID',
    `user_name`  VARCHAR(50) NOT NULL COMMENT '用户姓名',
    `user_phone` VARCHAR(13) NOT NULL COMMENT '用户联系电话',
    `user_sex`   VARCHAR(5)  NOT NULL COMMENT '用户性别',
    `;cers_id`   INT         NOT NULL COMMENT '用户证件ID外键',
    `user_card`  VARCHAR(18) NOT NULL COMMENT '身份证号'
);

#机舱类型表
DROP TABLE IF EXISTS `cabin_type`;
CREATE TABLE IF NOT EXISTS `cabin_type`
(
    `cabin_id`     INT PRIMARY KEY AUTO_INCREMENT COMMENT '机舱ID',
    `cabin_name`   VARCHAR(20) NOT NULL COMMENT '机舱类型名称',
    `cabin_status` INT         NOT NULL DEFAULT 1 COMMENT '机舱类型状态',# 1 可用 2 不可用
    `cabin_update` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '默认创建时间'
);
insert into cabin_type
values (0, '经济舱', 1, default);
insert into cabin_type
values (0, '商务舱', 1, default);
insert into cabin_type
values (0, '头等舱', 1, default);


#航空公司表
DROP TABLE IF EXISTS `airline_company`;
CREATE TABLE IF NOT EXISTS `airline_company`
(
    `airline_id`     INT PRIMARY KEY AUTO_INCREMENT COMMENT '航空公司ID',
    `airline_name`   VARCHAR(20) NOT NULL COMMENT '航空公司名称',
    `airline_logo`   VARCHAR(50) NOT NULL COMMENT '航空公司LOGO',
    `airline_model`  VARCHAR(50) NOT NULL COMMENT '飞机型号',
    `airline_status` INT         NOT NULL DEFAULT 1 COMMENT '航空公司状态',#1 可用 2 不可用
    `airline_update` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '默认创建时间'
);

insert into airline_company
values (0, '北京航空', '../assets/air_images/fm.png', '波音73V', 1, default);
insert into airline_company
values (0, '江苏航空', '../assets/air_images/mu.png', '波音12V', 1, default);
insert into airline_company
values (0, '南京航空', '../assets/air_images/ho.png', '波音23W', 1, default);


#航班记录表
DROP TABLE IF EXISTS `flight_records`;
CREATE TABLE IF NOT EXISTS `flight_records`
(
    `flight_id`         INT PRIMARY KEY AUTO_INCREMENT COMMENT '航班ID',
    `flight_number`     VARCHAR(50) NOT NULL COMMENT '航班编号',
    `flight_leave`      VARCHAR(50) NOT NULL COMMENT '出发地点',
    `flight_arrive`     VARCHAR(50) NOT NULL COMMENT '到达地点',
    `flight_leaveport`  VARCHAR(50) NOT NULL COMMENT '出发机场',
    `flight_arriveport` VARCHAR(50) NOT NULL COMMENT '到达机场',
    `flight_leavetime`  DATETIME    NOT NULL COMMENT '出发时间',
    `flight_arrivetime` DATETIME    NOT NULL COMMENT '抵达时间',
    `flight_duration`   VARCHAR(50) NOT NULL COMMENT '耗费时长',
    `flight_price`      FLOAT       NOT NULL COMMENT '机票价格',
    `cabins_id`         INT         NOT NULL COMMENT '外键机舱类型ID',
    `airlines_id`       INT         NOT NULL COMMENT '航空公司外键ID'
);

#航班记录表外键
ALTER TABLE `flight_records`
    ADD FOREIGN KEY FK_fC (`cabins_id`) REFERENCES `cabin_type` (`cabin_id`);
ALTER TABLE `flight_records`
    ADD FOREIGN KEY FK_fA (`airlines_id`) REFERENCES `airline_company` (`airline_id`);

#机票详情表
DROP TABLE IF EXISTS `ticket_details`;
CREATE TABLE IF NOT EXISTS `ticket_details`
(
    `ticket_id`     INT PRIMARY KEY AUTO_INCREMENT COMMENT '机票ID',
    `ticket_number` VARCHAR(255) NOT NULL COMMENT '机票详情编号',
    `operates_id`   INT          NOT NULL COMMENT '操作用户外键ID',
    `cabins_id`     INT          NOT NULL COMMENT '外键机舱类型ID',
    `airlines_id`   INT          NOT NULL COMMENT '航空公司外键ID',
    `flights_id`    INT          NOT NULL COMMENT '航班记录外键ID',
    `ticket_status` INT          NOT NULL DEFAULT 1 COMMENT '机票状态',#1 可用 2 不可用
    `ticket_update` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '默认创建时间'
);

#航班记录表的外键
ALTER TABLE `ticket_details`
    ADD FOREIGN KEY FK_TC (`cabins_id`) REFERENCES `cabin_type` (`cabin_id`);
ALTER TABLE `ticket_details`
    ADD FOREIGN KEY FK_TA (`airlines_id`) REFERENCES `airline_company` (`airline_id`);
ALTER TABLE `ticket_details`
    ADD FOREIGN KEY FK_TF (`flights_id`) REFERENCES `flight_records` (`flight_id`);
ALTER TABLE `ticket_details`
    ADD FOREIGN KEY FK_TUSER (`operates_id`) REFERENCES `operate_user` (`operate_id`);
#座位表
DROP TABLE IF EXISTS `air_seat`;
CREATE TABLE IF NOT EXISTS `air_seat`
(
    `seat_id`     INT PRIMARY KEY AUTO_INCREMENT COMMENT '座位ID',
    `seat_number` VARCHAR(50) NOT NULL COMMENT '座位编号',
    `seat_status` INT         NOT NULL DEFAULT 1 COMMENT '座位状态',#1 可用 2 不可用
    `operates_id` INT         NOT NULL COMMENT '操作用户外键ID',
    `cabins_id`   INT         NOT NULL COMMENT '机舱类型外键ID',
    `airlines_id` INT         NOT NULL COMMENT '航空公司外键ID',
    `flights_id`  INT         NOT NULL COMMENT '航班记录外键ID',
    `seat_update` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '默认创建时间'
);

select * from `air_seat` s
inner join `operate_user` u on s.operates_id = u.operate_id
inner join `cabin_type` t on s.cabins_id = t.cabin_id
inner join `airline_company` c on s.airlines_id = c.airline_id
inner join `flight_records` r on s.flights_id = r.flight_id
where s.operates_id = 4 and s.flights_id = 15 and s.seat_status = 0;

#座位表的外键
ALTER TABLE `air_seat`
    ADD FOREIGN KEY FK_AO (`operates_id`) REFERENCES `operate_user` (`operate_id`);
ALTER TABLE `air_seat`
    ADD FOREIGN KEY FK_AC (`cabins_id`) REFERENCES `cabin_type` (`cabin_id`);
ALTER TABLE `air_seat`
    ADD FOREIGN KEY FK_AA (`airlines_id`) REFERENCES `airline_company` (`airline_id`);
ALTER TABLE `air_seat`
    ADD FOREIGN KEY FK_SF (`flights_id`) REFERENCES `flight_records` (`flight_id`);
#订单记录表
DROP TABLE IF EXISTS `air_order`;
CREATE TABLE IF NOT EXISTS `air_order`
(
    `order_id`     INT PRIMARY KEY AUTO_INCREMENT COMMENT '订单记录ID',
    `order_number` VARCHAR(255) UNIQUE COMMENT '订单记录编号',
    `order_zfb_no` VARCHAR(50) NOT NULL COMMENT '支付宝账号',
    `order_update` TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '默认创建时间',
    `order_status` INT         NOT NULL DEFAULT 1 COMMENT '订单状态',#1 可用 2 不可用
    `operates_id`  INT         NOT NULL COMMENT '操作用户外键ID',
    `cabins_id`    INT         NOT NULL COMMENT '机舱类型外键ID',
    `airlines_id`  INT         NOT NULL COMMENT '航空公司外键ID',
    `flights_id`   INT         NOT NULL COMMENT '航班记录外键ID',
    `tickets_id`   INT         NOT NULL COMMENT '机票详情外键ID',
    `seats_id`     INT         NOT NULL COMMENT '座位外键ID'
);
#订单记录表的外键
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_AOA (`operates_id`) REFERENCES `operate_user` (`operate_id`);
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_TSAC (`cabins_id`) REFERENCES `cabin_type` (`cabin_id`);
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_TDCA (`airlines_id`) REFERENCES `airline_company` (`airline_id`);
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_TCA (`tickets_id`) REFERENCES `ticket_details` (`ticket_id`);
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_TFA (`seats_id`) REFERENCES `air_seat` (`seat_id`);
ALTER TABLE `air_order`
    ADD FOREIGN KEY FK_TFAS (`flights_id`) REFERENCES `flight_records` (`flight_id`);


#查询首页特价机票
select *
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id where flight_leavetime >'2021-04-24 12:00:0';



select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       f.flight_leavetime,
       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       airline_model,
       airline_status,
       airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
where f.cabins_id = 1;

select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       left(f.flight_leavetime, 16),
       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       airline_model,
       airline_status,
       airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
where f.flight_number = 'KN124';


select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       f.flight_leavetime,
       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       airline_model,
       airline_status,
       airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
where f.flight_leave = '北京'
  AND f.flight_arrive = '上海'
  AND f.flight_leavetime >= '2021-04-14 14:00:00'
  AND f.flight_arrivetime = '2021-04-14 14:00:00';


select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       f.flight_leavetime,
       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       airline_model,
       airline_status,
       airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
WHERE f.flight_leave = '北京'
  AND f.flight_arrive = '上海';


select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       DATE_FORMAT(f.flight_leavetime, '%Y-%m-%d %h:%m'),

       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       airline_model,
       airline_status,
       airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
WHERE f.flight_leave = '北京'
  AND f.flight_arrive = '上海'
  AND f.flight_leavetime >= '2021-04-24'
  AND str_to_date(f.flight_arrivetime, '%Y-%m-%d') = '2021-04-24';


select f.flight_id,
       f.flight_number,
       f.flight_leave,
       f.flight_arrive,
       f.flight_leaveport,
       f.flight_arriveport,
       f.flight_leavetime,
       f.flight_arrivetime,
       f.flight_duration,
       f.flight_price,
       f.cabins_id,
       f.airlines_id,
       c.airline_id,
       c.airline_name,
       c.airline_logo,
       c.airline_model,
       c.airline_status,
       c.airline_update,
       t.cabin_id,
       t.cabin_name,
       t.cabin_status,
       t.cabin_update
from `flight_records` f
         inner join `airline_company` c on f.airlines_id = c.airline_id
         inner join `cabin_type` t on f.cabins_id = t.cabin_id
where f.flight_id = 5;


select * from `ticket_details` d
inner join `operate_user` u on d.operates_id = u.operate_id
inner join `cabin_type` t on d.cabins_id = t.cabin_id
inner join `airline_company` c on d.airlines_id = c.airline_id
inner join `flight_records` r on d.flights_id = r.flight_id
where d.operates_id = 1 and d.flights_id = 4;

select  * from `flight_records`;
select * from `ticket_details`;
select * from `air_seat`;
select * from `operate_user`;
select * from `airline_company`;

select * from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where s.operates_id = 4 and s.flights_id = 15 and s.seat_status = 0;

select * from `air_seat` s inner join `operate_user` u on s.operates_id = u.operate_id inner join `cabin_type` t on s.cabins_id = t.cabin_id inner join `airline_company` c on s.airlines_id = c.airline_id inner join `flight_records` r on s.flights_id = r.flight_id where s.operates_id = 4 and s.flights_id = 15 and s.seat_status = 0;
select * from `air_order`;

select s.cabins_id from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where s.operates_id = 4 and s.flights_id = 15 and s.seat_status = 0 group by s.cabins_id;


select * from `ticket_details` d
        inner join `operate_user` u on d.operates_id = u.operate_id
        inner join `cabin_type` t on d.cabins_id = t.cabin_id
        inner join `airline_company` c on d.airlines_id = c.airline_id
        inner join `flight_records` r on d.flights_id = r.flight_id
        where d.operates_id = 7;

select * from `operate_user`;

select s.cabins_id from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where s.operates_id = 7 and s.flights_id = 17 and s.seat_status = 0 group by s.cabins_id;

select s.cabins_id from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where s.operates_id = 8 and s.flights_id = 14 and s.seat_status = 0 group by s.cabins_id;


select * from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where s.operates_id = 8 and s.flights_id = 14 and s.seat_status = 0;


 select * from `ticket_details` d
        inner join `operate_user` u on d.operates_id = u.operate_id
        inner join `cabin_type` t on d.cabins_id = t.cabin_id
        inner join `airline_company` c on d.airlines_id = c.airline_id
        inner join `flight_records` r on d.flights_id = r.flight_id
        where d.operates_id = 8;
select  * from `air_seat`;
select * from `operate_user`;
select * from `ticket_details`;

select * from `air_seat` s
        inner join `operate_user` u on s.operates_id = u.operate_id
        inner join `cabin_type` t on s.cabins_id = t.cabin_id
        inner join `airline_company` c on s.airlines_id = c.airline_id
        inner join `flight_records` r on s.flights_id = r.flight_id
        where  s.flights_id =14 and s.seat_status = 0;

select * from `operate_user`;

select * from `flight_records`;

select  * from `air_order`;
select * from `air_seat` where flights_id in ( 14,15,16) and seat_status = 0;
truncate table `air_seat`;
select * from `ticket_details`;

select  count(1) from `air_seat` where flights_id =3 and seat_status = 0;

select  * from `air_order` o
inner join `flight_records` f on o.flights_id = f.flight_id
inner join `cabin_type` t on o.cabins_id = t.cabin_id
inner join `airline_company` c on o.airlines_id = c.airline_id
where o.operates_id = 2;

select * from `cabin_type`;

select  * from flight_records;
#删除外键


truncate table `operate_user`;
truncate table `air_seat`;
truncate table `air_order`;
truncate table `ticket_details`;
