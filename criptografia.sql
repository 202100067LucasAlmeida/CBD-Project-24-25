use AdventureWorks;




drop procedure if exists security.sp_encript;
go
create procedure security.sp_encript
@value char(100),
@hashedValue VARBINARY(MAX) OUTPUT
as
	begin
		begin try
			declare @salt varbinary(16) = cast(100 as varbinary(16)); -- para efeitos demonstrativos usar um salt estatico
			set @hashedValue = hashbytes('SHA2_256', @value + cast(@salt as nvarchar(max)));
		end try
		begin catch
			declare @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
			declare @ErrorNumber int = ERROR_NUMBER();
			declare @ErrorSeverity int = ERROR_SEVERITY();

			exec security.sp_logError @ErrorMessage, @ErrorNumber, @ErrorSeverity;

			print 'Ocorreu um erro ao encriptar o valor.';
		end catch
	end;
go


CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'AdventureWorksPassword';

CREATE CERTIFICATE RecoveryCert
WITH SUBJECT = 'encriptacao de dados sensiveis';

CREATE SYMMETRIC KEY RecoveryKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE RecoveryCert;

go
CREATE PROCEDURE sp_getRecoveryQuestion (
    @userEmail char(30)
)
AS
BEGIN
    -- Abrir a chave simétrica
    OPEN SYMMETRIC KEY RecoveryKey DECRYPTION BY CERTIFICATE RecoveryCert;

    -- Recuperar e descriptografar os dados
    SELECT 
        CONVERT(NVARCHAR(255), DECRYPTBYKEY(q.security_question)) AS Question,
        CONVERT(NVARCHAR(255), DECRYPTBYKEY(uq.answer)) AS Answer
    FROM security._user u
	inner join security.userQuestion uq on u.user_email = uq._user_email
	inner join security.question q on uq.question_id = q.question_id
    WHERE u.user_email = @userEmail
	;

    -- Fechar a chave simétrica
    CLOSE SYMMETRIC KEY RecoveryKey;
END;