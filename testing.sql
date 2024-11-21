/*
 * O ficheiro testing.sql � designado para os testes da programa��o
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

select email from customer.customer;
-- Adicionando um user
exec security.sp_addUser 'jon24@adventure-works.com', 'umaSenh@MuitoFuerte!', 'qual o nome do meu gato?', 'kiara';

select * from security._user;
select * from security.question;
select * from security.userQuestion;

-- Success!

-- Editando um user. O tal do jon24@adventure-works.com
exec security.sp_editUser 'jon24@adventure-works.com', 'nov@P@ssn@omuitoforte'; -- Editar senha
exec security.sp_editUser 'jon24@adventure-works.com', null, 'qual o nome do meu primeiro bichinho?'; -- Editar quest�o de seguran�a
exec security.sp_editUser 'jon24@adventure-works.com', null, null, 'Fa�sca'; -- Editar resposta
exec security.sp_editUser 'jon24@adventure-works.com', '1234567890', 'quantos amigos?', 'nenhum'; -- Editando tudo

-- Success!

-- Removendo um User
exec security.sp_removeUser 'jon24@adventure-works.com';

-- Success

-- Recuperando senha de um user
exec security.sp_receivePass 'jon24@adventure-works.com', 'kiara'; -- Senha correta
exec security.sp_receivePass 'jon24@adventure-works.com', 'faisca'; -- Senha incorreta

select * from security.sentEmail;