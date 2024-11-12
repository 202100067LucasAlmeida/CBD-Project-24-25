-- Populate tables --
use AdventureWorksBetter;
-- Table Title --
-- Why? beacause it too much simple
select * from title;
select distinct c.Title from AdventureWorksLegacy.dbo.Customer$ c;

insert into title(title_description)
select distinct c.Title from AdventureWorksLegacy.dbo.Customer$ c
where c.Title != '';

-- ja está essa poha

-- Table Gender --
-- Why? I don't KNOW!
select * from gender;
select distinct c.Gender from AdventureWorksLegacy.dbo.Customer$ c;

insert into gender(gender_code, gender_description)
select distinct c.Gender,
case
	when c.Gender = 'M' then 'Male'
	when c.Gender = 'F' then 'Female'
	else 'Other'
end
from AdventureWorksLegacy.dbo.Customer$ c

-- garaio nem acreidito que funcionou :)

-- Table Marital
-- Why? Because I WANT!
select * from marital;
select distinct c.MaritalStatus from AdventureWorksLegacy.dbo.Customer$ c;

insert into marital(marital_code, marital_description)
select distinct c.MaritalStatus,
case
	when c.MaritalStatus = 'M' then 'Married'
	when c.MaritalStatus = 'S' then 'Single'
	else 'Other'
end
from AdventureWorksLegacy.dbo.Customer$ c

-- nada diferente...

-- Table Occupation
-- Why? Because I CAN DO WHATEVER I WANT!!!!
select * from occupation;
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer$ c;

insert into occupation(occupation_name)
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer$ c;

-- Coisa linda <3. Next

-- Table Education
select * from education;
select distinct c.Education from AdventureWorksLegacy.dbo.Customer$ c;

insert into education(education_name)
select distinct c.Education from AdventureWorksLegacy.dbo.Customer$ c;

-- Falador passa mal rapaz

-- Table _user

-- Table Question

-- Table Customer

-- Table Group
select * from _group;
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory$ t;

insert into _group(group_name)
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory$ t
where t.SalesTerritoryGroup != 'NA';

-- Table Currency
select * from currency;
select * from AdventureWorksLegacy.dbo.Currency$ c;

insert into currency(currency_name, currency_code)
select c.CurrencyName, c.CurrencyAlternateKey from AdventureWorksLegacy.dbo.Currency$ c;

-- Table ProductClass
select * from productClass;
select distinct p.Class from AdventureWorksLegacy.dbo.Products$ p;

insert into productClass(productClass_code)
select distinct p.Class from AdventureWorksLegacy.dbo.Products$ p
where p.Class != '';

-- Table ProductModel
select * from productModel;
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products$ p;

insert into productModel(productModel_name)
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products$ p;

-- Table ProductLine
select * from productLine;
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products$ p;

insert into productLine(productLine_code)
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products$ p
where p.ProductLine != '';

-- Table ProductStyle
select * from productStyle;
select distinct p.Style from AdventureWorksLegacy.dbo.Products$ p;
/*
	E os produtos sem Style?
select count(p.EnglishProductName), p.Style from AdventureWorksLegacy.dbo.Products$ p
group by p.Style;
*/

insert into productStyle(productStyle_code)
select distinct p.Style from AdventureWorksLegacy.dbo.Products$ p
where p.Style != '';

-- Vou parar por aqui temos uma coisa pra discutir