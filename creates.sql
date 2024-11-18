/*
* Cria��o tabelas
* Lucas - 202100067
* Jo�o - 202001541
*/
use master;
drop database if exists AdventureWorks;
create database AdventureWorks; -- Nome da BD � dito no enunciado feat. Luis
go

use AdventureWorks;

go
create schema customer;
go
-- Customer details --
create table customer.title(
	title_id int identity(1,1) not null,
	title_description char(10) not null,
	primary key(title_id)
);

create table customer.gender(
	gender_id int identity(1,1) not null,
	gender_code char(10) not null,
	gender_description char(15) not null,
	primary key(gender_id)
);

create table customer.marital(
	marital_id int identity(1,1) not null,
	marital_code char(10) not null,
	marital_description char(15) not null,
	primary key(marital_id)
);

create table customer.occupation(
	occupation_id int identity(1,1) not null,
	occupation_name char(30) not null,
	primary key(occupation_id)
);

create table customer.education(
	education_id int identity(1,1) not null,
	education_name char(30) not null,
	primary key(education_id)
);

create table _user(
	_user_id int identity(1,1) not null,
	user_email char(30) not null,
	user_password char(30) not null,
	user_answer varchar(200),
	primary key(_user_id)
);

create table question(
	question_id int identity(1,1) not null,
	security_question char(30) not null,
	primary key(question_id)
);

-- Customer -
create table customer.customer(
	customer_id int not null,
	title_id int,
	gender_id int,
	marital_id int,
	occupation_id int,
	education_id int,
	_user_id int,
	question_id int,
	first_name char(30) not null,
	middle_name char(30),
	last_name char(30) not null,
	customer_address char(50) not null,
	customer_phone char(15) not null,
	yearly_income int not null,
	cars_owned int not null,
	birth_date date not null,
	first_purchase date not null,
	primary key(customer_id),
	foreign key(title_id) references customer.title(title_id),
	foreign key(gender_id) references customer.gender(gender_id),
	foreign key(marital_id) references customer.marital(marital_id),
	foreign key(occupation_id) references customer.occupation(occupation_id),
	foreign key(education_id) references customer.education(education_id),
	foreign key(_user_id) references _user(_user_id),
	foreign key(question_id) references question(question_id)
);

create table customer.customerTitle(
	customer_id int not null,
	title_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(title_id) references customer.title(title_id)
);

-- Territory --

go
create schema territory
go

create table territory._group(
	group_id int identity(1,1) not null,
	group_name char(20) not null,
	primary key(group_id)
);

create table territory.country(
	country_id int identity(1,1) not null,
	group_id int,
	country_name char(20) not null,
	country_code char(10) not null,
	primary key(country_id),
	foreign key(group_id) references territory._group(group_id)
);

create table territory.region(
	region_id int identity(1,1) not null,
	country_id int,
	region_name char(20) not null,
	primary key(region_id),
	foreign key(country_id) references territory.country(country_id)
);

create table territory._state(
	state_id int identity(1,1) not null,
	region_id int,
	state_name char(20) not null,
	state_code char(10) not null,
	primary key(state_id, region_id),
	foreign key(region_id) references territory.region(region_id)
);

create table territory.city(
	city_id int identity(1,1) not null,
	state_id int,
	region_id int,
	city_name char(50) not null,
	postal_code varchar(20) not null,
	primary key(city_id, state_id, region_id),
	foreign key(state_id, region_id) references territory._state(state_id, region_id)
);

-- Alteration customer --
alter table customer.customer
add
	city_id int,
	state_id int,
	region_id int;

alter table customer.customer
add constraint fk_customer_city
foreign key (city_id, state_id, region_id) references territory.city(city_id, state_id, region_id);

-- Currency --
create table currency(
	currency_id int identity(1,1) primary key, -- auto increment
	currency_name varchar(40) not null,
	currency_code char(10) not null -- Code s� com uma letra n� Morais porra
);

go
create schema product
go

-- product class
create table product.class (
	class_id int identity(1,1) primary key,
	class_code varchar(10) not null
);

-- Product model
create table product.model (
	model_id int identity(1,1) primary key,
	model_name varchar(100) not null
);

-- Product line
create table product.line (
	line_id int identity(1,1) primary key,
	line_code varchar(10) not null
);

-- Product style
create table product.style (
	style_id int identity(1,1) primary key,
	style_code varchar(10) not null
);

-- Product size range
create table product.sizeRange (
	sizeRange_id int identity(1,1) primary key,
	sizeRange_description varchar(100) not null
);

-- Product category
create table product.category (
	category_id int identity(1,1) primary key,
	category_name varchar(100) not null,
	category_parentCategory int 
	foreign key (category_parentCategory) references product.category(category_id) 
		on delete no action 
		on update no action
);

-- Product color
create table product.color (
	color_id int identity(1,1) primary key,
	color_name varchar(100) not null
);

-- Size unit
create table product.sizeUnit(
	sizeUnit_id int identity(1,1) primary key,
	sizeUnit_description varchar(10) not null
);
-- Weigth unit
create table product.weigthUnit(
	weigthUnit_id int identity(1,1) primary key,
	weigthUnit_description varchar(10) not null
);

-- Product
create table product._product(
	product_id int primary key,
	product_description varchar(100) not null,
	product_dealerPrice float,
	product_listPrice float,
	product_daysToManufacture float not null, -- permitir 1.5 (dia e meio)?
	product_standardCost float,
	product_finishedGoods binary default(1),
	product_size float,
	product_weight float	
);

-- product productSizeRange
create table product.productSizeRange(
	product_id int,
	sizeRange_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(sizeRange_id) references product.sizeRange(sizeRange_id)
);

-- product productStyle
create table product.productStyle(
	product_id int,
	style_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key (style_id) references product.style(style_id)
);

-- product productLine
create table product.productLine(
	product_id int,
	line_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key (line_id) references product.line(line_id)
);

-- product productSizeUnit
create table product.productSizeUnit(
	product_id int,
	sizeUnit_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(sizeUnit_id) references product.sizeUnit(sizeUnit_id),
);

-- product productWeigthUnit
create table product.productWeigthUnit(
	product_id int,
	weigthUnit_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(weigthUnit_id) references product.weigthUnit(weigthUnit_id)
);

-- product productColor
create table product.productColor(
	product_id int,
	color_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(color_id) references product.color(color_id)
);

-- product productModel
create table product.productModel(
	product_id int,
	model_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(model_id) references product.model(model_id),
);

-- product productClass
create table product.productClass(
	product_id int,
	class_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(class_id) references product.class(class_id),
);

-- product productCategory
create table product.productCategory(
	product_id int,
	category_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(category_id) references product.category(category_id)
);

go
create schema sales
go

-- Sales header
create table sales.salesHeader(
	salesHeader_id int identity(1,1) primary key,
	salesHeader_dueDate date not null,
	salesHeader_orderDate date not null,
	salesHeader_shipDate date not null,

	currency_id int,
	country_id int,

	foreign key(currency_id) references currency(currency_id),
	foreign key(country_id) references territory.country(country_id)
);
-- Sales details
create table sales.salesDetails(
	salesDetails_id int identity(1,1) primary key,
	salesDetails_lineNumber int not null,
	salesDetails_quantity int not null,
	salesDetails_unitPrice float not null,
	salesDetails_taxAmount float not null,
	salesDetails_freight float not null
);

-- sales header details
create table sales.salesHeaderDetails(
	salesHeader_id int,
	salesDetails_id int,

	primary key(salesHeader_id, salesDetails_id),
	foreign key(salesHeader_id) references sales.salesHeader(salesHeader_id),
	foreign key (salesDetails_id) references sales.salesDetails(salesDetails_id)
);

-- product sales details
create table sales.productSalesDetails(
	salesDetails_id int,
	product_id int,
	primary key(salesDetails_id, product_id),
	foreign key(salesDetails_id) references sales.salesDetails(salesDetails_id),
	foreign key(product_id) references product._product(product_id)
);