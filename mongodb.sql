use AdventureWorks;

--select * from product.ListarProdudos
--for json auto;

select 
	s.sales_id,
	s.sales_lineNumber,
	s.sales_quantity,
	s.sales_freight,
	s.sales_unitPrice,
	s.sales_taxAmount,
	s.sales_orderDate,
	s.sales_dueDate,
	s.sales_shipDate,
	
	p.product_id,
	p.product_name,
	p.product_standardCost,
	cc.category_name as 'product_category',
	ct.category_name as 'product_subcategory'
	
from sales.saleProducts sp
	inner join sales.sale s on s.sales_id = sp.sales_id and s.sales_lineNumber = sp.sales_lineNumber
	inner join product._product p on p.product_id = sp.product_id
	inner join product.productCategory pct on p.product_id = pct.product_id
	inner join product.category ct on ct.category_id = pct.category_id
	inner join product.category cc on cc.category_id = ct.category_parentCategory;

