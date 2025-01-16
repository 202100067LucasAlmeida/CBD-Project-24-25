/*
 * O ficheiro queries_fase_2.sql � designado para a parte da programa��o
 * (desenvolvimento de indices)
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

-- comandos para monitorar desempenho

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Pesquisa de vendas por cidade
select distinct
	c.city_name as 'city', 
	s.state_code as 'state code',
	count(sl.sales_id) as 'total sales'
from territory.city c
	inner join territory._state s on c.state_id = s.state_id
	inner join territory.region r on r.region_id = s.region_id
	inner join territory.country co on co.country_id = r.country_id
	inner join sales.saleCountry sc on co.country_id = sc.country_id
	inner join sales.sale sl on sl.sales_id = sc.sales_id 
		and sl.sales_lineNumber = sc.sales_lineNumber
group by c.city_name, s.state_code
order by 'city'
;

-- Pesquisa de produtos associados a vendas com valor total superior a 1000
select distinct
	p.product_name as 'produtos em vendas com total superior a 1000'
from sales.saleProducts sp
	inner join product._product p on sp.product_id = p.product_id
where sp.sales_id in (select s.sales_id
						from sales.sale s
						group by s.sales_id
						having sum(s.sales_unitPrice*s.sales_quantity) > 1000);


-- numero de produtos vendidos por categoria
select 
	c.category_name as 'categoria', 
	cc.category_name as 'subcategoria', 
	count(sp.product_id) as 'n de produtos vendidos'
from sales.saleProducts sp
	inner join product._product p on sp.product_id = p.product_id
	inner join product.productCategory pc on pc.product_id = p.product_id
	inner join product.category c on c.category_id = pc.category_id
	inner join product.category cc on cc.category_id = c.category_parentCategory
group by c.category_name, cc.category_name
order by c.category_name;

-- Índices

drop index if exists idx_city_state_id on territory.city;
drop index if exists idx_state_region_id on territory._state;
drop index if exists idx_region_country_id on territory.region;
drop index if exists idx_country_id on territory.country;
drop index if exists idx_saleCountry on sales.saleCountry;
drop index if exists idx_sale on sales.sale;

-- Índices territory.city
create index idx_city_state_id on territory.city (state_id, city_name);

-- Índices territory._state
create index idx_state_region_id on territory._state (region_id, state_code);

-- Índices territory.region
create index idx_region_country_id on territory.region (country_id);

-- Índices territory.country
create index idx_country_id on territory.country (country_id);

-- Índices sales.saleCountry
create index idx_saleCountry on sales.saleCountry (country_id, sales_id, sales_lineNumber);

-- Índices sales.sale
create index idx_sale on sales.sale (sales_id, sales_lineNumber);
