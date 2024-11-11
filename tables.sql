use master;
drop database if exists AdventureWorksBetter;
create database AdventureWorksBetter;
go

use AdventureWorksBetter;

-- New tables criation --

-- Customer details --
create table title(
	title_id int not null,
	title_description char(10) not null,
	primary key(title_id)
);

create table gender(
	gender_id int not null,
	gender_code char(10) not null,
	gender_description char(15) not null,
	primary key(gender_id)
);

create table marital(
	marital_id int not null,
	marital_code char(10) not null,
	marital_description char(15) not null,
	primary key(marital_id)
);

create table occupation(
	occupation_id int not null,
	occupation_name char(30) not null,
	primary key(occupation_id)
);

create table education(
	education_id int not null,
	education_name char(30) not null,
	primary key(education_id)
);

create table _user(
	_user_id int not null,
	user_email char(30) not null,
	user_password char(30) not null,
	primary key(_user_id)
);

create table question(
	question_id int not null,
	security_question char(30) not null,
	primary key(question_id)
);

-- Customer -
create table customer(
	customer_id int not null,
	title_id int,
	gender_id int,
	marital_id int,
	occupation_id int,
	education_id int,
	_user_id int,
	question_id int,
	first_name char(30) not null,
	m_iddle_name char(30),
	last_name char(30) not null,
	customer_address char(50) not null,
	customer_phone char(15) not null,
	yearly_income int not null,
	cars_owned int not null,
	birth_date date not null,
	first_purchase date not null,
	primary key(customer_id),
	foreign key(title_id) references title(title_id),
	foreign key(gender_id) references gender(gender_id),
	foreign key(marital_id) references marital(marital_id),
	foreign key(occupation_id) references occupation(occupation_id),
	foreign key(education_id) references education(education_id),
	foreign key(_user_id) references _user(_user_id),
	foreign key(question_id) references question(question_id)
);

-- Territory --

create table _group(
	group_id int not null,
	group_name char(20) not null,
	primary key(group_id)
);

create table country(
	country_id int not null,
	group_id int,
	country_name char(20) not null,
	country_code char(10) not null,
	primary key(country_id),
	foreign key(group_id) references _group(group_id)
);

create table region(
	region_id int not null,
	country_id int,
	region_name char(20) not null,
	primary key(region_id),
	foreign key(country_id) references country(country_id)
);

create table _state(
	state_id int not null,
	region_id int,
	state_name char(20) not null,
	state_code char(10) not null,
	primary key(state_id, region_id),
	foreign key(region_id) references region(region_id)
);

create table city(
	city_id int not null,
	state_id int,
	region_id int,
	city_name char(20) not null,
	postal_code int not null,
	primary key(city_id, state_id, region_id),
	foreign key(state_id, region_id) references _state(state_id, region_id)
);

-- Alteration customer --
alter table customer
add
	city_id int,
	state_id int,
	region_id int;

alter table customer
add constraint fk_customer_city
foreign key (city_id, state_id, region_id) references city(city_id, state_id, region_id);

-- Currency --
create table currency(
	currency_id int identity(1,1) primary key, -- auto increment
	currency_name varchar(40) not null,
	currency_code char(1) not null
);

-- product class
create table productClass (
	productClass_id int identity(1,1) primary key,
	productClass_code varchar(10) not null
);

-- Product model
create table productModel (
	productModel_id int identity(1,1) primary key,
	productModel_name varchar(100) not null
);

-- Product line
create table productLine (
	productLine_id int identity(1,1) primary key,
	productLine_code varchar(10) not null
);

-- Product style
create table productStyle (
	productStyle_id int identity(1,1) primary key,
	productStyle_code varchar(10) not null
);

-- Product size range
create table productSizeRange (
	productSizeRange_id int identity(1,1) primary key,
	productSizeRange_description varchar(100) not null
);

-- Product category
create table productCategory (
	productCategory_id int identity(1,1) primary key,
	productCategory_name varchar(100) not null,
	productCategory_parentCategory int 
	foreign key (productCategory_parentCategory) references productCategory(productCategory_id) 
		on delete no action 
		on update no action
);

-- Product color
create table productColor (
	productColor_id int identity(1,1) primary key,
	productColor_name varchar(100) not null
);

-- Size unit
create table sizeUnit(
	sizeUnit_id int identity(1,1) primary key,
	sizeUnit_description varchar(10) not null
);
-- Weigth unit
create table weigthUnit(
	weigthUnit_id int identity(1,1) primary key,
	weigthUnit_description varchar(10) not null
);

-- Product
create table _product(
	product_id int identity(1,1) primary key,
	product_description varchar(100) not null,
	product_dealerPrice float not null,
	product_listPrice float not null,
	product_daysToManufacture float not null, -- permitir 1.5 (dia e meio)?
	product_standardCost float not null,
	product_finishedGoods binary default(1),
	product_size float not null,
	product_weight float not null,

	productColor int,
	productCategory int,
	productSizeRange int,
	productStyle int,
	productClass int,
	productModel int,
	productLine int,
	productSizeUnit int,
	productWeigthUnit int,

	foreign key(productColor) references productColor(productColor_id),
	foreign key(productCategory) references productCategory(productCategory_id),
	foreign key(productSizeRange) references productSizeRange(productSizeRange_id),
	foreign key(productStyle) references productStyle(productStyle_id),
	foreign key(productClass) references productClass(productClass_id),
	foreign key(productModel) references productModel(productModel_id),
	foreign key(productLine) references productLine(productLine_id),
	foreign key(productSizeUnit) references sizeUnit(sizeUnit_id),
	foreign key(productWeigthUnit) references weigthUnit(weigthUnit_id)
);

-- Sales header
create table salesHeader(
	salesHeader_id int identity(1,1) primary key,
	salesHeader_dueDate date not null,
	salesHeader_orderDate date not null,
	salesHeader_shipDate date not null,

	currency_id int,
	country_id int,

	foreign key(currency_id) references currency(currency_id),
	foreign key(country_id) references country(country_id)
);
-- Sales details
create table salesDetails(
	salesDetails_id int identity(1,1) primary key,
	salesDetails_lineNumber int not null,
	salesDetails_quantity int not null,
	salesDetails_unitPrice float not null,
	salesDetails_taxAmount float not null,
	salesDetails_freight float not null
);

-- sales header details
create table salesHeaderDetails(
	salesHeader_id int,
	salesDetails_id int,

	primary key(salesHeader_id, salesDetails_id),
	foreign key(salesHeader_id) references salesHeader(salesHeader_id),
	foreign key (salesDetails_id) references salesDetails(salesDetails_id)
);

-- product sales details
create table productSalesDetails(
	salesDetails_id int,
	product_id int,
	primary key(salesDetails_id, product_id),
	foreign key(salesDetails_id) references salesDetails(salesDetails_id),
	foreign key(product_id) references _product(product_id)
);