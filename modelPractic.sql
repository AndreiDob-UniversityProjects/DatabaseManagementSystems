/*create database practicDBMS
go*/
use practicDBMS
go

if object_id('Sales','U') is not null
	drop table Sales 
if object_id('Toys','U') is not null
	drop table Toys 
if object_id('ToyStores','U') is not null
	drop table ToyStores 
if object_id('Producers','U') is not null
	drop table Producers 
if object_id('Categories','U') is not null
	drop table Categories 


create table Producers(
	p_id INT identity(1,1) primary key ,
	name varchar(50),
	phone int,
	website varchar(50))

create table Categories(
	c_id INT identity(1,1) primary key ,
	name varchar(50),
	description varchar(50))

create table Toys(
	t_id INT identity(1,1) primary key ,
	name varchar(50),
	description varchar(50),
	producer_id int references Producers(p_id),
	category_id int references Categories(c_id))

create table ToyStores(
	ts_id INT identity(1,1) primary key ,
	name varchar(50),
	website varchar(50))

create table Sales(
	--s_id INT identity(1,1) primary key ,
	toy_id int references Toys(t_id),
	toyStore_id int references ToyStores(ts_id),
	PRIMARY KEY (toy_id, toyStore_id))

insert into Producers(name,phone,website) values
('Andy',1234,'www.andy.com'),
('John',1234,'www.john.com');

insert into Categories(name,description) values
('category1','lorem ipsum');

insert into Toys(name,description,producer_id,category_id) values
('toy1','toy_description',1,1),
('toy2','toy_description',1,1),
('toy3','toy_description',2,1),
('toy4','toy_description',2,1),
('toy5','toy_description',2,1);

select * from Producers;
select * from Categories;
select * from Toys;

--deadlock transaction1

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	BEGIN Tran
	SELECT * FROM Toys WHERE t_id=1
	--costly operation
	WaitFor Delay '00:00:05'

	UPDATE Toys set description = 'DEADLOCK' WHERE t_id = 2
	PRINT 'This was the victim'
	Rollback Transaction











