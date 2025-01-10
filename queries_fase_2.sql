use AdventureWorks;
/*
-- Pesquisa de vendas por cidade
select distinct
	c.city_name as 'city', 
	s.state_code as 'state code',
	sum(count(sl.sales_id)) as 'total sales'
from territory.city c
	inner join territory._state s on c.state_id = s.state_id
	inner join territory.region r on r.region_id = s.region_id
	inner join territory.country co on co.country_id = r.country_id
	inner join sales.saleCountry sc on co.country_id = sc.country_id
	inner join sales.sale sl on sl.sales_id = sc.sales_id 
		and sl.sales_lineNumber = sc.sales_lineNumber
group by c.city_name, s.state_code, sl.sales_id
order by 'city'
;
*/

-- Pesquisa de produtos associadosa vendas com valor total superior a 1000

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
