drop database if exists AdventureWorksBetter;
create database AdventureWorksBetter;
go

use AdventureWorksBetter;

-- New tables criation --

-- Customer details --
create table title(
	titleID int not null,
	title_description char(10) not null,
	primary key(titleID)
);

create table gender(
	genderID int not null,
	gender_code char(10) not null,
	gender_description char(15) not null,
	primary key(genderID)
);

create table marital(
	maritalID int not null,
	marital_code char(10) not null,
	marital_description char(15) not null,
	primary key(maritalID)
);

create table occupation(
	occupationID int not null,
	occupation_name char(30) not null,
	primary key(occupationID)
);

create table education(
	educationID int not null,
	education_name char(30) not null,
	primary key(educationID)
);

create table _user(
	userID int not null,
	user_email char(30) not null,
	user_password char(30) not null,
	primary key(userID)
);

create table question(
	questionID int not null,
	security_question char(30) not null,
	primary key(questionID)
);

-- Customer -
create table customer(
	customerID int not null,
	titleID int,
	genderID int,
	maritalID int,
	occupationID int,
	educationID int,
	userID int,
	questionID int,
	first_name char(30) not null,
	middle_name char(30),
	last_name char(30) not null,
	customer_address char(50) not null,
	customer_phone char(15) not null,
	yearly_income int not null,
	cars_owned int not null,
	birth_date date not null,
	first_purchase date not null,
	primary key(customerID),
	foreign key(titleID) references title(titleID),
	foreign key(genderID) references gender(genderID),
	foreign key(maritalID) references marital(maritalID),
	foreign key(occupationID) references occupation(occupationID),
	foreign key(educationID) references education(educationID),
	foreign key(userID) references _user(userID),
	foreign key(questionID) references question(questionID)
);

-- Territory --

create table _group(
	groupID int not null,
	group_name char(20) not null,
	primary key(groupID)
);

create table country(
	countryID int not null,
	groupID int,
	country_name char(20) not null,
	country_code char(10) not null,
	primary key(countryID),
	foreign key(groupID) references _group(groupID)
);

create table region(
	regionID int not null,
	countryID int,
	region_name char(20) not null,
	primary key(regionID),
	foreign key(countryID) references country(countryID)
);

create table _state(
	stateID int not null,
	regionID int,
	state_name char(20) not null,
	state_code char(10) not null,
	primary key(stateID, regionID),
	foreign key(regionID) references region(regionID)
);

create table city(
	cityID int not null,
	stateID int,
	regionID int,
	city_name char(20) not null,
	postal_code int not null,
	primary key(cityID, stateID, regionID),
	foreign key(stateID, regionID) references _state(stateID, regionID)
);

-- alteration customer --
alter table customer
add
	cityID int,
	stateID int,
	regionID int;

alter table customer
add constraint fk_customer_city
foreign key (cityID, stateID, regionID) references city(cityID, stateID, regionID);