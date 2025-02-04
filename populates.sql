/*
 * O ficheiro populates.sql � respons�vel pela popula��o de todas as tabelas criadas
 * na nova base de dados AdventureWorks.
 *
 * ========== PROGRAMADORES ==========
 * Lucas Alexandre S. F. de Almeida - 202100067
 * Jo�o Pedro M. Morais - 202001541
 *
 * ========== DOCENTE ==========
 * Professor Lu�s Damas
 *
 */
use AdventureWorks;

/* ==================================
 * ========== Table Title ===========
 * ==================================
 */
insert into customer.title(title_description)
select distinct c.Title from AdventureWorksLegacy.dbo.Customer c
where c.Title != '';

/* ===================================
 * ========== Table Gender ===========
 * ===================================
 */
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
insert into customer.occupation(occupation_name)
select distinct c.Occupation from AdventureWorksLegacy.dbo.Customer c;

/* ======================================
 * ========== Table Education ===========
 * ======================================
 */
insert into customer.education(education_name)
select distinct c.Education from AdventureWorksLegacy.dbo.Customer c;

/* ==================================
 * ========== Table Group ===========
 * ==================================
 */
insert into territory._group(group_name)
select distinct t.SalesTerritoryGroup from AdventureWorksLegacy.dbo.SalesTerritory t
where t.SalesTerritoryGroup != 'NA';

/* =====================================
 * ========== Table Currency ===========
 * =====================================
 */
insert into currency.currency(currency_name, currency_code)
select c.CurrencyName, c.CurrencyAlternateKey from AdventureWorksLegacy.dbo.Currency c;

/* ==================================
 * ========== Table Class ===========
 * ==================================
 */
insert into product.class(class_code)
select distinct p.Class from AdventureWorksLegacy.dbo.Products p
where p.Class != '';

/* ==================================
 * ========== Table Model ===========
 * ==================================
 */
insert into product.model(model_name)
select distinct p.ModelName from AdventureWorksLegacy.dbo.Products p;

/* =================================
 * ========== Table Line ===========
 * =================================
 */
insert into product.line(line_code)
select distinct p.ProductLine from AdventureWorksLegacy.dbo.Products p
where p.ProductLine != '';

/* ==================================
 * ========== Table Style ===========
 * ==================================
 */
insert into product.style(style_code)
select distinct p.Style from AdventureWorksLegacy.dbo.Products p
where p.Style != '';

-- Table ProductColor
insert into product.color
select distinct p.Color from AdventureWorksLegacy.dbo.Products p
where p.Color != 'NA';

/* ====================================
 * ========== Table Country ===========
 * ====================================
 */
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
insert into territory.region(country_id, region_name)
select country_id, st.SalesTerritoryRegion
from territory.country c 
join AdventureWorksLegacy.dbo.SalesTerritory st on c.country_name = st.SalesTerritoryCountry;

/* ==================================
 * ========== Table State ===========
 * ==================================
 */
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

/* ======================================
 * ========== Table Size Unit ===========
 * ======================================
 */
insert into product.sizeUnit(sizeUnit_description)
select distinct(SizeUnitMeasureCode) from AdventureWorksLegacy.dbo.Products where SizeUnitMeasureCode != '';

/* ========================================
 * ========== Table Weight Unit ===========
 * ========================================
 */
insert into product.weigthUnit(weigthUnit_description)
select distinct(WeightUnitMeasureCode) from AdventureWorksLegacy.dbo.Products where WeightUnitMeasureCode != '';

/* =======================================
 * ========== Table Size Range ===========
 * =======================================
 */
-- faz sentido guardar 'NA' para quando uma medida nao esteja disponivel?
-- NA s�o produtos que n�o tem tamanho, n�o � que n�o esteja dispon�vel.  - L
insert into product.sizeRange(sizeRange_description)
select distinct(SizeRange) from AdventureWorksLegacy.dbo.Products where SizeRange != 'NA';

/* ==================================
 * ========== Table Category ===========
 * ==================================
 */
select distinct ps.EnglishProductSubcategoryName as 'subcategory', ps.ProductSubcategoryKey as 'subcategory key', p.EnglishProductCategoryName as 'category' from AdventureWorksLegacy.dbo.Products p
inner join AdventureWorksLegacy.dbo.ProductSubCategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey
order by 'subcategory key'
;

-- 1� Passo - popular as principais categorias, null como parent pois nao existe nenhum acima destas
insert into product.category(category_name, category_parentCategory)
select distinct EnglishProductCategoryName as 'category', null from AdventureWorksLegacy.dbo.Products;

-- 2� Passo - popular as subcategorias, preencher com o codigo da categoria principal
insert into product.category(category_name, category_parentCategory)
select distinct ps.EnglishProductSubcategoryName as 'subcategory', 
(
	select category_id from product.category where category_name = p.EnglishProductCategoryName
)as 'category' -- selecionar o id da categoria principal
from AdventureWorksLegacy.dbo.Products p
inner join AdventureWorksLegacy.dbo.ProductSubCategory ps on ps.ProductSubcategoryKey = p.ProductSubcategoryKey;

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

-- table productClass
insert into product.productClass(product_id, class_id)
select distinct _p.product_id, c.class_id from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.class c on c.class_code = p.Class
where p.Class != ''
;

-- table productModel
insert into product.productModel(product_id, model_id)
select distinct _p.product_id, m.model_id from AdventureWorksLegacy.dbo.Products p
inner join product._product _p on _p.product_id = p.ProductKey
inner join product.model m on m.model_name = p.ModelName
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

-- productSizeRange
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
insert into customer.customer(customer_id, first_name, middle_name, last_name, email, customer_address, customer_phone, yearly_income, cars_owned, birth_date, first_purchase)
select distinct
	c.CustomerKey,
	c.FirstName,
	case
		when c.MiddleName is not NULL then c.MiddleName
		when c.MiddleName is NULL then ''
	end as MiddleName,
	c.LastName,
	c.EmailAddress,
	c.AddressLine1,
	c.Phone,
	c.YearlyIncome,
	c.NumberCarsOwned,
	c.BirthDate,
	c.DateFirstPurchase
from AdventureWorksLegacy.dbo.Customer c	
;

-- customer title
insert into customer.customerTitle(customer_id, title_id)
select distinct cc.customer_id, t.title_id
from AdventureWorksLegacy.dbo.Customer c
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join customer.title t on t.title_description = c.Title
;

-- customer gender
insert into customer.customerGender(customer_id, gender_id)
select distinct cc.customer_id, g.gender_id
from AdventureWorksLegacy.dbo.Customer c
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join customer.gender g on g.gender_code = c.Gender
;

-- customer occupation
insert into customer.customerOccupation(customer_id, occupation_id)
select distinct cc.customer_id, o.occupation_id
from AdventureWorksLegacy.dbo.Customer c
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join customer.occupation o on o.occupation_name = c.Occupation
;

-- customer marital
insert into customer.customerMarital(customer_id, marital_id)
select distinct cc.customer_id, m.marital_id
from AdventureWorksLegacy.dbo.Customer c
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join customer.marital m on m.marital_code = c.MaritalStatus
;

-- customer education
insert into customer.customerEducation(customer_id, education_id)
select distinct cc.customer_id, e.education_id
from AdventureWorksLegacy.dbo.Customer c
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join customer.education e on e.education_name = c.Education
;

-- customer city
insert into customer.customerCity(customer_id, city_id, state_id, region_id)
select distinct cc.customer_id, ct.city_id, ct.state_id, ct.region_id
from AdventureWorksLegacy.dbo.Customer c
inner join AdventureWorksLegacy.dbo.SalesTerritory st on st.SalesTerritoryKey = c.SalesTerritoryKey
inner join customer.customer cc on cc.customer_id = c.CustomerKey
inner join territory.city ct on ct.city_name = c.City and ct.postal_code = c.PostalCode
inner join territory._state s on s.state_id = ct.state_id
where s.state_code = c.StateProvinceCode
;


--sales
insert into sales.sale(sales_id, sales_lineNumber, sales_quantity, sales_unitPrice, sales_taxAmount, sales_freight, sales_dueDate, sales_orderDate, sales_shipDate)
select distinct
	s.SalesOrderNumber,
	s.SalesOrderLineNumber,
	s.OrderQuantity,
	s.UnitPrice,
	s.TaxAmt,
	s.Freight,
	CAST(s.DueDate AS DATE) as 'DueDate',
	CAST(s.OrderDate AS DATE) as 'OrderDate',
	CAST(s.ShipDate AS DATE) as 'ShipDate'
from AdventureWorksLegacy.dbo.Sales s
order by SalesOrderNumber, SalesOrderLineNumber
;

-- saleCountry
insert into sales.saleCountry(sales_id, sales_lineNumber, country_id)
select distinct ss.sales_id, ss.sales_lineNumber, c.country_id
from AdventureWorksLegacy.dbo.Sales s
inner join AdventureWorksLegacy.dbo.SalesTerritory st on st.SalesTerritoryKey = s.SalesTerritoryKey
inner join sales.sale ss on s.SalesOrderNumber = ss.sales_id and s.SalesOrderLineNumber = ss.sales_lineNumber
inner join territory.country c on c.country_name = st.SalesTerritoryCountry
order by ss.sales_id, ss.sales_lineNumber
;

-- saleCurrency
insert into sales.saleCurrency(sales_id, sales_lineNumber, currency_id)
select distinct ss.sales_id, ss.sales_lineNumber, c.currency_id
from AdventureWorksLegacy.dbo.Sales s
inner join sales.sale ss on s.SalesOrderNumber = ss.sales_id and s.SalesOrderLineNumber = ss.sales_lineNumber
inner join currency.currency c on c.currency_id = s.CurrencyKey
order by ss.sales_id, ss.sales_lineNumber
;

-- saleCustomer
insert into sales.saleCustomer(sales_id, sales_lineNumber, customer_id)
select distinct ss.sales_id, ss.sales_lineNumber, c.customer_id
from AdventureWorksLegacy.dbo.Sales s
inner join sales.sale ss on s.SalesOrderNumber = ss.sales_id and s.SalesOrderLineNumber = ss.sales_lineNumber
inner join customer.customer c on c.customer_id = s.CustomerKey
order by ss.sales_id, ss.sales_lineNumber
;

-- saleProducts
insert into sales.saleProducts(sales_id, sales_lineNumber, product_id)
select distinct ss.sales_id, ss.sales_lineNumber, p.product_id
from AdventureWorksLegacy.dbo.Sales s
inner join sales.sale ss on s.SalesOrderNumber = ss.sales_id and s.SalesOrderLineNumber = ss.sales_lineNumber
inner join product._product p on p.product_id = s.ProductKey
order by ss.sales_id, ss.sales_lineNumber
;