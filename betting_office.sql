drop database betting_office;

create database betting_office;

SET GLOBAL log_bin_trust_function_creators = 1;

use betting_office;

create table owner_info(
	director_id int primary key not null,
    director_name varchar(30),
    director_surname varchar(30),
    director_salary int not null,
    director_startdate date
);



create table sponsori(
	sponsor_id int primary key not null,
	sponsor_name varchar(30), 
	contract_value int, 
	contract_startdate date
);


create table players
(
	player_id int primary key not null,
    player_name varchar(30),
    player_surname varchar(30),
    balance int,
    biggest_win int
);

select * from players;



create table betting_office(
	office_id int primary key not null,
	office_name varchar(30) not null, 
	director_id int not null, 
	sponsor_id int not null, 
	player_id int not null,
	constraint cn1 foreign key (director_id) references owner_info(director_id) on delete cascade,
    constraint cn2 foreign key (sponsor_id) references sponsori(sponsor_id) on delete cascade,
    constraint cn3 foreign key (player_id) references players(player_id) on delete cascade
);


insert into owner_info
(director_id, director_name, director_surname, director_salary, director_startdate)
values
(1, 'Edgar', 'Vasilevski', 1000, '2003/12/10'), 
(2, 'Kiril', 'Stankevich', 700, '2002/10/02'), 
(3, 'Natalia', 'Shisha', 800, '2003/03/15'),
(4, 'Alex', 'Kush', 1000, '2002/01/24'),
(5, 'Gregori', 'Podkidnoi', 900, '2003/10/12');

select * from owner_info;

insert into sponsori
(sponsor_id, sponsor_name, contract_value, contract_startdate)
values
(2, 'Belgazprom', 10000, '2004/09/09'), 
(3, 'BSU', 7000, '2002/11/10'), 
(1, 'National_team', 8000, '2005/02/11'),
(5, 'International', 10000, '2003/11/19'),
(4, 'MTZ', 9000, '2006/07/12');

select * from sponsori;


insert into players
(player_id, player_name, player_surname, balance, biggest_win)
values
(4, 'Vas9', 'Pupkin', 100, 300), 
(2, 'Pet9', 'Zalupkin', 75, 150), 
(1, 'Sast9', 'Navchenko', 200, 400),
(3, 'Nast9', 'Anatoli', 300, 200),
(5, 'Kat9', 'Belska9', 50, 150);

select * from players;


insert into betting_office
(office_id, office_name, director_id, sponsor_id, player_id)
values
(1, '1XBET', 2, 3, 1), 
(2, 'PARIMATCH', 3, 1, 2), 
(3, '365BET', 1, 4, 3),
(4, 'LEON', 4, 2, 4),
(5, 'CSGOLOUNGE', 5, 5, 5);

select * from betting_office;

drop procedure bet;

DELIMITER //
create procedure bet(in player_id int, in n int, in result varchar(30))
begin
	update players
		set balance = if(result = 'Win', balance + n, balance - n),
			biggest_win = if(result = 'Win' and n >= biggest_win, n, biggest_win)
    where player_id = players.player_id;
end//
DELIMITER ; 

select * from players;
call bet(1, 100, 'Win');

DELIMITER //
create trigger betting before update on players
for each row
begin
	if (select balance from players where player_id = new.player_id) < 0 or new.balance < 0 or new.balance > old.balance * 2 then
		signal sqlstate '45000'
			set message_text = 'Not enough money';
    end if;
end//
DELIMITER ;

select * from owner_info;

select * from players;

select * from betting_office;


DELIMITER //
create procedure transfer(in sender int, in rec int, in sum integer)
begin

declare var int;


set var = (select balance from players
where player_id=sender);

set sum = convert(sum, unsigned);

CREATE TEMPORARY TABLE table1 (player_id int, player_name varchar(30), player_surname varchar(30), balance int, biggest_win int); 
INSERT INTO table1 SELECT player_id, player_name, player_surname, balance, biggest_win FROM players where player_id = rec; 
 
start transaction;

if (var>=0 and sum<=var and sum>=0) 
then
update players
set balance=balance-sum
where player_id=sender and balance = var;
if row_count()>0
	then 
    delete from players
    where player_id = rec;
    if row_count()>0
		then
        insert into players
		(player_id,player_name,player_surname,balance,biggest_win)
		select player_id, player_name, player_surname, balance+sum, biggest_win
        from table1 order by player_id;
        commit;
        else rollback;
        end if;
else rollback;
end if;
end if;
drop table table1;
end//
DELIMITER ;

drop procedure transfer;
call transfer(3,2,100);

select * from players;


DELIMITER //
create function idgenerator()
returns int
begin
return floor(rand() * 90000 + 10000);
end//
DELIMITER ;

DELIMITER //
create procedure createRow(in f1 varchar(30), in f2 varchar(30), in f3 datetime, out id int)
begin
declare localid int;
set localid=idgenerator();
insert into sponsori
()
values
(localid, f1, f2, f3);
set id = localid;
end//
DELIMITER ;
