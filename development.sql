/*
 * O ficheiro development.sql é designado para a parte da programação
 * (desenvolvimento de sp's e functions)
 * na nova base de dados AdventureWorks.
 *
 * ========== PROGRAMADORES ==========
 * Lucas Alexandre S. F. de Almeida - 202100067
 * João Pedro M. Morais - 202001541
 *
 * ========== DOCENTE ==========
 * Professor Luís Damas
 *
 */

 drop procedure if exists security.sp_logError
 go
 create procedure security.sp_logError
	@ErrorMessage nvarchar(4000),
    @ErrorNumber int,
    @ErrorSeverity int
 as
 begin
	insert into error.errorLog(ErrorMessage, ErrorNumber, ErrorSeverity, UserName)
	values(@ErrorMessage, @ErrorNumber, @ErrorSeverity, SYSTEM_USER)
 end;
 go

 drop procedure if exists security.sp_addUser
 go
 create procedure security.sp_addUser
	@email char(100),
	@password char(100),
	@securityQuestion char(200),
	@answer varchar(200)
 as
 begin
	begin try
		insert into security._user(user_email, user_password)
		values(@email, @password)
		
		insert into security.question(security_question)
		values(@securityQuestion)

		insert into security.userQuestion(_user_email, question_id, answer)
		select u.user_email, q.question_id, answer = @answer from security._user u
		join security.question q on q.security_question = @securityQuestion
		where u.user_email = @email;

		print 'Utilizador adicionado com sucesso!';
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao adicionar o utilizador. Utilizador não adicionado.';
	end catch;
 end;
 go

 drop procedure if exists security.sp_editUser
 go
create procedure security.sp_editUser
	@email char(100),
	@newPassword char(100) = null,
	@newSecurityQuestion char(200) = null,
	@newAnswer char(200) = null
as
begin
	begin try
		update security._user
		set 
			user_password = COALESCE(@newPassword, user_password)
			where user_email = @email;
		
		update security.question
		set
			security_question = COALESCE(@newSecurityQuestion, security_question)
			where question_id = (select uq.question_id
								 from security.userQuestion uq
								 where _user_email = @email);

		update security.userQuestion
		set
			answer = COALESCE(@newAnswer, answer)
			where _user_email = @email;

		print 'O utilizador foi editado com sucesso!';
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao editar o utilizador. Utilizador não foi editado.';
	end catch;
end;
go

drop procedure if exists security.sp_removeUser
go
create procedure security.sp_removeUser
	@email char(100)
as
begin
	begin try
		declare @questionID int = (select question_id from security.userQuestion where _user_email = @email);
		
		delete from security.userQuestion
		where _user_email = @email;

		delete from security.question
		where question_id = @questionID;

		delete from security._user
		where user_email = @email;

		print 'O utilizador foi removido com sucesso!'
	end try
	begin catch
	declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao remover o utilizador. Utilizador não foi removido.';
	end catch;
end;
go

drop procedure if exists security.sp_receivePass
go
create procedure security.sp_receivePass
	@email char(100),
	@securityAnswer char(200)
as
begin
	begin try
		declare @correctAnswer char(200) = (select uq.answer from security.userQuestion uq
											where uq._user_email = @email);;
		declare @newPass char(200);

		if @correctAnswer is null
		begin
			print 'Usuário não encontrado ou sem questão de segurança definida.'
			return;
		end

		if @correctAnswer != @securityAnswer
		begin
			print 'Resposta incorreta à pergunta de segurança.'
			return;
		end

		set @newPass = LEFT(NEWID(),8);
		
		update security._user
		set user_password = @newPass
		where user_email = @email;

		-- enviar email
		insert into security.sentEmail(destinatary, _message)
		values(
			   @email,
			   concat('Sua senha foi recuperada. Nova Passe: ', @newPass, '. Faça a alteração de sua senha o quanto antes.')
			   );

		print 'Senha recuperada e enviada com sucesso!';
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao recuperar a senha do utilizador. Nova senha não foi enviada.';
	end catch;
end;
go

drop procedure if exists customer.sp_saleInformation
go
create procedure customer.sp_saleInformation
	@orderDate date,
	@customerID int
as
begin
	select c.customer_id as 'ID Cliente', concat_ws(' ', c.first_name, c.last_name) as 'Cliente', 
	   s.sales_id as 'Número do Pedido', s.sales_lineNumber as 'Número de Linha', 
	   s.sales_quantity as 'Quantidade', s.sales_unitPrice as 'Preço Unitário', 
	   (s.sales_unitPrice + s.sales_taxAmount + s.sales_freight)* s.sales_quantity as 'Preço Final com taxas',
	   s.sales_orderDate as 'Data do Pedido', s.sales_dueDate as 'Data de Vencimento', 
	   s.sales_shipDate as 'Data de Envio'
	from sales.sale s
		join sales.saleCustomer sc on sc.sales_id = s.sales_id and sc.sales_lineNumber = s.sales_lineNumber
		join customer.customer c on c.customer_id = sc.customer_id
	where c.customer_id = @customerID and s.sales_orderDate = @orderDate;
end;
go