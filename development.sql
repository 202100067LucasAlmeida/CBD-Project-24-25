/*
 * O ficheiro development.sql � designado para a parte da programa��o
 * (desenvolvimento de sp's e functions)
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

		print 'Utilizador adicionado com sucesso!'
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao adicionar o utilizador. Utilizador n�o adicionado.'
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

		print 'O utilizador foi editado com sucesso!'
	end try
	begin catch
		declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
		declare @ErrorNumber int = ERROR_NUMBER();
		declare @ErrorSeverity int = ERROR_SEVERITY();

		exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

		print 'Ocorreu um erro ao editar o utilizador. Utilizador n�o foi editado.'
	end catch;
end;
go

drop procedure if exists security.sp_removeUser
go
create procedure security.sp_removeUser
as

begin

end;
go