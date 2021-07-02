create database BLR_shop;

use BLR_shop;

create table manufact
(
	manuf_id int primary key not null,
    manuf_name varchar(50) not null,
    manuf_country varchar(20) not null,
    manuf_phone varchar(20),
    manuf_adress varchar(50)
);

create table product
(
	prod_id int primary key not null,
    prod_name varchar(30) not null,
    prod_type enum("beer","vodka","wine"),
    prod_manuf_ref_id int not null,
    prod_quantity int,
    constraint cn1 foreign key (prod_manuf_ref_id) references manufact(manuf_id) on delete cascade
);

insert into manufact
(manuf_id, manuf_name, manuf_country, manuf_phone, manuf_adress)
values
(1,"Alivaria","Belarus","+375297520012","Minsk, Kiseleva 30"),
(2,"Krinytsa","Belarus","+375337805611","Minsk, Radialnaya 52"),
(3,"Bulbash","Belarus","+375296000033","Minsk, Nezavisimosty 4");


insert into product
(prod_id, prod_name, prod_type, prod_manuf_ref_id, prod_quantity)
values
(1,"Alivaria 10","beer", 1, 47),
(2,"Porter","beer", 2, 13),
(3,"Motsnae","beer", 2, 100),
(4,"Alivaria 7","beer", 1, 49),
(5,"Bulbash classic","vodka", 3, 11);


