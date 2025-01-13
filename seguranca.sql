use AdventureWorks;

-- CRIAR CONTAS
create login adminUser with password = 'adworksADM';
create user adminUser for login adminUser;

create login salesUser with password = 'adworksSales';
create user salesUser for login salesUser;

create login territoryUser with password = 'adworksTerritory';
create user territoryUser for login territoryUser;

-- ATRIBUIR PERMISSOES
-- administrator
	grant control to adminUser; -- atribui acesso total � base de dados (servidor excluido)

-- salesPerson
-- permiss�es de escrita, leitura e update em sales
	grant select, insert, update, delete on schema::[sales] to salesUser;

-- permiss�es de leitura nas restantes tabelas
	grant select on schema::[customer] to salesUser;
	grant select on schema::[currency] to salesUser;
	grant select on schema::[product] to salesUser;
	grant select on schema::[territory] to salesUser;
-- remover permiss�es de leitura a tabelas de gest�o da bd
	deny select on schema::[security] to salesUser;
	deny select on schema::[error] to salesUser;


-- salesTerritoryPerson
	grant select, insert, update, delete on schema::[territory] to territoryUser;

	-- permiss�es de leitura nas restantes tabelas
	grant select on schema::[customer] to territoryUser;
	grant select on schema::[currency] to territoryUser;
	grant select on schema::[product] to territoryUser;
	grant select on schema::[sales] to territoryUser;
-- remover permiss�es de leitura a tabelas de gest�o da bd
	deny select on schema::[security] to territoryUser;
	deny select on schema::[error] to territoryUser;