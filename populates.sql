/*
 * O ficheiro populates.sql é responsável pela população de todas as tabelas criadas
 * na nova base de dados AdventureWorks.
 *
 * ========== PROGRAMADORES ==========
 * Lucas Alexandre S. F. de Almeida - 202100067
 * João Pedro M. Morais - 202001541
 *
 * ========== DOCENTE ==========
 * Professor Luís Damas <3
 *
 */
use AdventureWorks;

/* ==================================
 * ========== Table Title ===========
 * ==================================
 */
select * from customer.title;
select distinct c.Title from AdventureWorksLegacy.dbo.Customer c;

insert into customer.title(title_description)
select distinct c.Title from AdventureWorksLegacy.dbo.Customer c
where c.Title != '';

/* ===================================
 * ========== Table Gender ===========
 * ===================================
 */
select * from customer.gender;
select distinct c.Gender from AdventureWorksLegacy.dbo.Customer c;

insert into customer.gender(gender_code, gender_description)
select distinct c.Gender,
case
	when c.Gender = 'M' then 'Male'
	when c.Gender = 'F' then 'Female'
end
from AdventureWorksLegacy.dbo.Customer c

/* ====================================
 * ========== Table Marital ===========
 * ====================================
 */
select * from customer.marital;
select distinct c.MaritalStatus from AdventureWorksLegacy.dbo.Customer c;

insert into customer.marital(marital_code, marital_description)
select distinct c.MaritalStatus,
case
	when c.MaritalStatus = 'M' then 'Married'
	when c.MaritalStatus = 'S' then 'Single'
end
from AdventureWorksLegacy.dbo.Customer c

/* =======================================
 * ========== Table Occupation ===========
 * =======================================  
 */
select * from customer.occupation;
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer c;

insert into customer.occupation(occupation_name)
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer c;

/* ======================================
 * ========== Table Education ===========
 * ======================================
 */
select * from customer.education;
select distinct c.Education from AdventureWorksLegacy.dbo.Customer c;

insert into customer.education(education_name)
select distinct c.Education from AdventureWorksLegacy.dbo.Customer c;

/* =================================
 * ========== Table User ===========
 * =================================
 */

 /* ====================================
 * ========== Table Question ===========
 * =====================================
 */

/* =====================================
 * ========== Table Customer ===========
 * =====================================
 */

/* ==================================
 * ========== Table Group ===========
 * ==================================
 */
select * from territory._group;
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory t;

insert into territory._group(group_name)
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory t
where t.SalesTerritoryGroup != 'NA';

/* =====================================
 * ========== Table Currency ===========
 * =====================================
 */
select * from currency.currency;
select * from AdventureWorksLegacy.dbo.Currency c;

insert into currency.currency(currency_name, currency_code)
select c.CurrencyName, c.CurrencyAlternateKey from AdventureWorksLegacy.dbo.Currency c;

/* ==================================
 * ========== Table Class ===========
 * ==================================
 */
select * from product.class;
select distinct p.Class from AdventureWorksLegacy.dbo.Products p;

insert into product.class(class_code)
select distinct p.Class from AdventureWorksLegacy.dbo.Products p
where p.Class != '';

/* ==================================
 * ========== Table Model ===========
 * ==================================
 */
select * from product.model;
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products p;

insert into product.model(model_name)
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products p;

/* =================================
 * ========== Table Line ===========
 * =================================
 */
select * from product.line;
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products p;

insert into product.line(line_code)
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products p
where p.ProductLine != '';

/* ==================================
 * ========== Table Style ===========
 * ==================================
 */
select * from product.style;
select distinct p.Style from AdventureWorksLegacy.dbo.Products p;

insert into product.style(style_code)
select distinct p.Style from AdventureWorksLegacy.dbo.Products p
where p.Style != '';

-- Table ProductColor
select * from product.color;
select distinct Color from AdventureWorksLegacy.dbo.Products p;

insert into product.color
select distinct p.Color from AdventureWorksLegacy.dbo.Products p
where p.Color != 'NA';

/* ====================================
 * ========== Table Country ===========
 * ====================================
 */
select * from territory._group;
select * from territory.country;

insert into territory.country(group_id, country_name, country_code) 
select distinct group_id, st.SalesTerritoryCountry, c.CountryRegionCode
from territory._group g 
join AdventureWorksLegacy.dbo.SalesTerritory st 
on st.SalesTerritoryGroup = g.group_name
inner join AdventureWorksLegacy.dbo.Customer c
on st.SalesTerritoryKey = c.SalesTerritoryKey;

/* ===================================
 * ========== Table Region ===========
 * ===================================
 */
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
from territory.country c 
join AdventureWorksLegacy.dbo.SalesTerritory st on c.country_name = st.SalesTerritoryCountry;

/* ==================================
 * ========== Table State ===========
 * ==================================
 */
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

/* =================================
 * ========== Table City ===========
 * =================================
 */
insert into territory.city(state_id, region_id, city_name, postal_code)
select distinct
	s.state_id,
	s.region_id,
	c.City,
	c.PostalCode
from AdventureWorksLegacy.dbo.Customer c
inner join AdventureWorksLegacy.dbo.SalesTerritory st
on c.SalesTerritoryKey = st.SalesTerritoryKey
inner join territory._state s
on s.state_name = c.StateProvinceName
;

select city_name, state_name, region_name, postal_code 
from territory.city c
inner join territory._state s on s.state_id = c.state_id 
inner join territory.region r on r.region_id = c.region_id
;

/* ======================================
 * ========== Table Size Unit ===========
 * ======================================
 */
insert into product.sizeUnit(sizeUnit_description)
select distinct(SizeUnitMeasureCode) from AdventureWorksLegacy.dbo.Products where SizeUnitMeasureCode != '';

select * from product.sizeUnit;

/* ========================================
 * ========== Table Weight Unit ===========
 * ========================================
 */
insert into product.weigthUnit(weigthUnit_description)
select distinct(WeightUnitMeasureCode) from AdventureWorksLegacy.dbo.Products where WeightUnitMeasureCode != '';

select * from product.weigthUnit;

/* =======================================
 * ========== Table Size Range ===========
 * =======================================
 */
-- faz sentido guardar 'NA' para quando uma medida nao esteja disponivel?
-- NA são produtos que não tem tamanho, não é que não esteja disponível.  - L
insert into product.sizeRange(sizeRange_description)
select distinct(SizeRange) from AdventureWorksLegacy.dbo.Products where SizeRange != 'NA';

select * from product.SizeRange;

/* ==================================
 * ========== Table Category ===========
 * ==================================
 */
select distinct ps.EnglishProductSubcategoryName as 'subcategory', ps.ProductSubcategoryKey as 'subcategory key', p.EnglishProductCategoryName as 'category' from AdventureWorksLegacy.dbo.Products p
inner join AdventureWorksLegacy.dbo.ProductSubCategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
order by 'subcategory key'
;

-- 1° Passo - popular as principais categorias, null como parent pois nao existe nenhum acima destas
insert into product.category(category_name, category_parentCategory)
select distinct EnglishProductCategoryName as 'category', null from AdventureWorksLegacy.dbo.Products;

-- 2° Passo - popular as subcategorias, preencher com o codigo da categoria principal
insert into product.category(category_name, category_parentCategory)
select distinct ps.EnglishProductSubcategoryName as 'subcategory', 
(
	select category_id from product.category where category_name = p.EnglishProductCategoryName
)as 'category' -- selecionar o id da categoria principal
from AdventureWorksLegacy.dbo.Products p
inner join AdventureWorksLegacy.dbo.ProductSubCategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey;

select * from product.category;

/* ====================================
 * ========== Table Product ===========
 * ====================================
 */
insert into product._product(
	product_id,
	product_name,
	product_description,
	product_dealerPrice,
	product_listPrice,
	product_daysToManufacture,
	product_standardCost,
	product_finishedGoods,
	product_size,
	product_weight
)
select distinct 
	p.ProductKey,
	p.EnglishProductName,
	p.EnglishDescription,
	p.DealerPrice,
	p.ListPrice,
	p.DaysToManufacture,
	p.StandardCost,
	case
		when p.FinishedGoodsFlag = 1 then 1
		else 0
	end as FinishedGoodsFlag,
	p.Size,
	p.Weight
from AdventureWorksLegacy.dbo.Products p;
select * from product._product;


/* ==========================================
 * ========== Table Product Color ===========
 * ==========================================
 */

insert into product.productColor(product_id, color_id)
select _p.product_id, c.color_id from AdventureWorksLegacy.dbo.Products p
inner join product.color c on c.color_name = p.Color
inner join product._product _p on _p.product_id = p.ProductKey;

select distinct p.ProductKey, p.EnglishProductName, p.Color from AdventureWorksLegacy.dbo.Products p
where p.Color != 'NA' -- com o where a conta dá certa
;
select p.product_id, c.color_name from product.productColor pc
inner join product._product p on p.product_id = pc.product_id
inner join product.color c on c.color_id = pc.color_id
;

-- existem produtos com NA na cor 
-- diferenca entre as queries: 341 vs 397

-- table productClass
insert into product.productClass(product_id, class_id)
select distinct _p.product_id, c.class_id from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.class c on c.class_code = p.Class
where p.Class != ''
;
select * from product.productClass;

-- table productModel
insert into product.productModel(product_id, model_id)
select distinct _p.product_id, m.model_id from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.model m on m.model_name = p.ModelName
;

select p.product_name, m.model_name from product.productModel pm
inner join product._product p on p.product_id = pm.product_id
inner join product.model m on m.model_id = pm.model_id
;

-- productLine
insert into product.productLine(product_id, line_id)
select distinct _p.product_id, l.line_id from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.line l on l.line_code = p.ProductLine
;
select * from product.productLine;

-- productCategory
insert into product.productCategory(product_id, category_id)
select distinct _p.product_id, c.category_id
from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.category c on c.category_id = p.ProductSubcategoryKey;

--teste: listar um produto, categoria e subcategoria
select distinct
 p.product_id
 ,cc.category_name as 'category'
 ,c.category_name as 'subcategory'
from product.productCategory pc
inner join product._product p on p.product_id = pc.product_id
inner join product.category c on c.category_id = pc.category_id
inner join product.category cc on cc.category_id = c.category_parentCategory;

-- productSizeRange
select * from product.sizeRange;

insert into product.productSizeRange(product_id, sizeRange_id)
select distinct _p.product_id, sr.sizeRange_id 
from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.sizeRange sr on sr.sizeRange_description = p.SizeRange
;

-- productSizeUnit
insert into product.productSizeUnit(product_id, sizeUnit_id)
select distinct _p.product_id, su.sizeUnit_id
from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.sizeUnit su on su.sizeUnit_description = p.SizeUnitMeasureCode
;

-- productWeigthUnit
insert into product.productWeigthUnit(product_id, weigthUnit_id)
select distinct _p.product_id, wu.weigthUnit_id
from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.weigthUnit wu on wu.weigthUnit_description = p.WeightUnitMeasureCode
;

-- productStyle
insert into product.productStyle(product_id, style_id)
select distinct _p.product_id, s.style_id
from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.style s on s.style_code = p.Style
;

-- customer