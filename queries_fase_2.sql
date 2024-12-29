use AdventureWorks;

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
group by c.city_name, s.state_code, sl.sales_id
order by 'city'
;