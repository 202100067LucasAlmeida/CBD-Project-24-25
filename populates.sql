-- Populate tables --
use AdventureWorksBetter;

-- Table Title --
select * from customer.title;
select distinct c.Title from AdventureWorksLegacy.dbo.Customer c;

insert into customer.title(title_description)
select distinct c.Title from AdventureWorksLegacy.dbo.Customer c
where c.Title != '';

-- Table Gender --
select * from customer.gender;
select distinct c.Gender from AdventureWorksLegacy.dbo.Customer c;

insert into customer.gender(gender_code, gender_description)
select distinct c.Gender,
case
	when c.Gender = 'M' then 'Male'
	when c.Gender = 'F' then 'Female'
end
from AdventureWorksLegacy.dbo.Customer c

-- Table Marital
select * from customer.marital;
select distinct c.MaritalStatus from AdventureWorksLegacy.dbo.Customer c;

insert into customer.marital(marital_code, marital_description)
select distinct c.MaritalStatus,
case
	when c.MaritalStatus = 'M' then 'Married'
	when c.MaritalStatus = 'S' then 'Single'
end
from AdventureWorksLegacy.dbo.Customer c

-- Table Occupation
select * from customer.occupation;
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer c;

insert into customer.occupation(occupation_name)
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer c;

-- Table Education
select * from customer.education;
select distinct c.Education from AdventureWorksLegacy.dbo.Customer c;

insert into customer.education(education_name)
select distinct c.Education from AdventureWorksLegacy.dbo.Customer c;

-- Table _user

-- Table Question

-- Table Customer

-- Table Group
select * from territory._group;
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory t;

insert into territory._group(group_name)
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory t
where t.SalesTerritoryGroup != 'NA';

-- Table Currency
select * from currency;
select * from AdventureWorksLegacy.dbo.Currency c;

insert into currency(currency_name, currency_code)
select c.CurrencyName, c.CurrencyAlternateKey from AdventureWorksLegacy.dbo.Currency c;

-- Table ProductClass
select * from product.productClass;
select distinct p.Class from AdventureWorksLegacy.dbo.Products p;

insert into product.productClass(productClass_code)
select distinct p.Class from AdventureWorksLegacy.dbo.Products p
where p.Class != '';

-- Table ProductModel
select count(*) from product.productModel;
select distinct count(p.ModelName) from AdventureWorksLegacy.dbo.Products p;

insert into product.productModel(productModel_name)
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products p;

-- Table ProductLine
select * from product.productLine;
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products p;

insert into product.productLine(productLine_code)
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products p
where p.ProductLine != '';

-- Table ProductStyle
select * from product.productStyle;
select distinct p.Style from AdventureWorksLegacy.dbo.Products p;

insert into product.productStyle(productStyle_code)
select distinct p.Style from AdventureWorksLegacy.dbo.Products p
where p.Style != '';

-- table Country
select * from territory._group;
select * from territory.country;

insert into territory.country(group_id, country_name, country_code) 
select distinct group_id, st.SalesTerritoryCountry, c.CountryRegionCode
from territory._group g 
join AdventureWorksLegacy.dbo.SalesTerritory st 
on st.SalesTerritoryGroup = g.group_name
inner join AdventureWorksLegacy.dbo.Customer c
on st.SalesTerritoryKey = c.SalesTerritoryKey;

-- table region
select * from territory.region;
select * from territory.country;
select 
	st.SalesTerritoryRegion,
	st.SalesTerritoryCountry,
	c.CountryRegionCode,
	c.CountryRegionName
from AdventureWorksLegacy.dbo.SalesTerritory st
inner join AdventureWorksLegacy.dbo.Customer c
on c.SalesTerritoryKey = st.SalesTerritoryKey;

insert into territory.region(country_id, region_name)
select country_id, st.SalesTerritoryRegion
from territory.country c join AdventureWorksLegacy.dbo.SalesTerritory st on c.country_name = st.SalesTerritoryCountry;
select * from territory.region;

-- table _state
select * from territory._state;
select 
	SalesTerritoryRegion,
	SalesTerritoryCountry,
	SalesTerritoryGroup,
	City,
	StateProvinceCode,
	StateProvinceName,
	CountryRegionCode,
	CountryRegionName,
	PostalCode 
from AdventureWorksLegacy.dbo.SalesTerritory st
inner join AdventureWorksLegacy.dbo.Customer c
on c.SalesTerritoryKey = st.SalesTerritoryKey;

insert into territory._state(region_id, state_name, state_code)
select distinct region_id, c.StateProvinceName, c.StateProvinceCode
from AdventureWorksLegacy.dbo.SalesTerritory st
inner join territory.region r on r.region_name = st.SalesTerritoryRegion
inner join AdventureWorksLegacy.dbo.Customer c
on c.SalesTerritoryKey = st.SalesTerritoryKey;