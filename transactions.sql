use AdventureWorks;

-- Adicionar produto a uma venda
set transaction isolation level read committed; -- garante que a transação não leia dados não confirmados, evitando problemas como dirty reads.
begin transaction;
	declare @sale_id varchar(20);
	declare @sale_lineNumber int;
	declare @product_id int;
	
	-- ler de um serviço web ou aplicação
	-- neste caso, fazer uma transação com dados mock
	set @sale_id = 'SO51176'
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
		GETDATE(),	-- devia-se ir buscar as datas anteriores e/ou alterar por datas novas
		GETDATE(),	-- devia-se ir buscar as datas anteriores e/ou alterar por datas novas
		GETDATE()	-- devia-se ir buscar as datas anteriores e/ou alterar por datas novas
	);

	set @product_id = 212;
	insert into sales.saleProducts (sales_id, sales_lineNumber, product_id)
	values (@sale_id, @sale_lineNumber, @product_id);
	
commit transaction;

-- Atualizar o preço de um produto
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- garante que nenhuma outra transação leia ou altere o preço do produto enquanto a transação está em andamento.
BEGIN TRANSACTION;
	declare @oldPrice float;
	declare @newPrice float;
	declare @productId int;

	set @productId = 212; -- mock produto
	set @oldPrice = (select p.product_standardCost from product._product p where p.product_id = @productId)
	set @newPrice = @oldPrice * 1.5; -- atualizar o preco 

-- Atualizar o preço do produto
UPDATE product._product
SET product_standardCost = @newPrice
WHERE product_id = @ProductID;

COMMIT TRANSACTION;

-- Calcular o total de vendas no ano corrente
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- garante que todas as leituras feitas durante a transação permaneçam consistentes e não sejam afetadas por inserts ou updates de outras transações.
BEGIN TRANSACTION;
waitfor delay '00:00:20';
select sum(p.product_listPrice)as 'total de vendas no ano corrente' from sales.saleProducts sp
	inner join sales.sale s on sp.sales_id = s.sales_id and sp.sales_lineNumber = s.sales_lineNumber
	inner join product._product p on sp.product_id = p.product_id
where year(s.sales_orderDate) = year(GETDATE());
COMMIT TRANSACTION;

-- Evitar inserções duplicadas
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- garante que nenhuma outra transação crie um user enquanto esta está em andamento.

BEGIN TRANSACTION;
	declare @email char(30);

	--set @email = 'jon24@adventure-works.com'; -- email mock, de user que já existe
	set @email = 'pablo@adventure-works.com'; -- email mock, de user que não existe


IF NOT EXISTS (
    SELECT 1 FROM security._user u WHERE u.user_email = @email
)
BEGIN
    exec security.sp_addUser @email, 'umaSenh@MuitoFuerte!', 'qual o nome do meu gato?', 'kiara';
END
COMMIT TRANSACTION;
