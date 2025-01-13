-- Adicionar produto a uma venda
set transaction isolation level read committed;
begin transaction;
	declare @sale_id varchar(20);
	declare @sale_lineNumber int;
	declare @product_id int;
	
	-- ler de um serviço web ou aplicação
	-- neste caso, fazer uma transação com dados mock
	set @sale_id = 'SO51176'
	select * from sales.saleProducts where sales_id = 'SO51176';
	set @sale_lineNumber = (select top 1 (sales_lineNumber + 1) from sales.saleProducts where sales_id = @sale_id
							order by sales_lineNumber DESC);
	insert into sales.sale (sales_id, sales_lineNumber, sales_quantity, sales_unitPrice, sales_taxAmount, sales_freight, sales_dueDate, sales_orderDate, sales_shipDate)
	values (
		@sale_id,
		@sale_lineNumber,
		1,
		10.0,
		0.5,
		0,
		GETDATE(),
		GETDATE(),
		GETDATE()
	);

	set @product_id = 210;
	insert into sales.saleProducts (sales_id, sales_lineNumber, product_id)
	values (@sale_id, @sale_lineNumber, @product_id);
	select * from sales.saleProducts where sales_id = 'SO51176';

commit transaction;

-- Atualizar o preço de um produto
-- Calcular o total de vendas no ano corrente
-- Evitar inserções duplicadas
