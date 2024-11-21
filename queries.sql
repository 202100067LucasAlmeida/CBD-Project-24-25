--Nº de “Products”;
select count(ProductKey) as 'Nº de produtos' from AdventureWorksLegacy.dbo.Products;
select count(product_id) as 'Nº de produtos' from AdventureWorks.product._product;

--Nº de “Sales”;
select count(distinct SalesOrderNumber) as 'Nº de sales' from AdventureWorksLegacy.dbo.Sales;
select count(distinct sales_id) as 'Nº de sales' from AdventureWorks.sales.sale;

--Total de vendas por “Customer”;
select CustomerKey as 'Customer', count(distinct SalesOrderNumber) as 'Nº de sales' from AdventureWorksLegacy.dbo.Sales group by CustomerKey;
select s.customer_id as 'Customer', count(distinct s.sales_id) as 'Nº de sales' from AdventureWorks.sales.saleCustomer s group by s.customer_id;

--Total monetário de vendas por ano;
select sum(s.OrderQuantity*s.UnitPrice) as 'Total monetário de vendas por ano'
from AdventureWorksLegacy.dbo.Sales s
group by YEAR(s.OrderDate);

select sum(sales_quantity*sales_unitPrice) as 'Total monetário de vendas por ano' 
from AdventureWorks.sales.sale group by YEAR(sales_orderDate);

--Total monetário de vendas por ano e por “Product”.
select 
s.ProductKey as 'Produto',
sum(s.OrderQuantity*s.UnitPrice) as 'Total monetário de vendas por ano e produto'
from AdventureWorksLegacy.dbo.Sales s
group by YEAR(s.OrderDate), s.ProductKey;


select 
sp.product_id as 'Produto',
sum(s.sales_quantity*s.sales_unitPrice) as 'Total monetário de vendas por ano e produto' 
from AdventureWorks.sales.sale s 
inner join AdventureWorks.sales.saleProducts sp on sp.sales_id = s.sales_id and sp.sales_lineNumber = s.sales_lineNumber
group by YEAR(sales_orderDate), sp.product_id;





