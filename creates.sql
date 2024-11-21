/*
 * O ficheiro creates.sql é responsável pela criação de todas as tabelas propostas
 * para a nova base de dados normalizada AdventureWorks.
 *
 * ========== PROGRAMADORES ==========
 * Lucas Alexandre S. F. de Almeida - 202100067
 * João Pedro M. Morais - 202001541
 *
 * ========== DOCENTE ==========
 * Professor Luís Damas 
 *
 */

--exec sp_who;

use master;
drop database if exists AdventureWorks;
create database AdventureWorks; 
go

use AdventureWorks;

/* =====================================
 * ========== Schema Customer ==========
 * =====================================
 * 
 * Schema dedicado a todas as informações referentes ao Cliente.
 */
go
create schema customer;
go
/* ============================
 * ========== Title ===========
 * ============================
 *
 * Tabela dedicada aos títulos atribuídos aos Clientes.
 */
create table customer.title(
	title_id int identity(1,1) not null,
	title_description char(10) not null,
	primary key(title_id)
);

/* ============================
 * ========== Gender ==========
 * ============================
 *
 * Tabela dedicada aos gêneros atribuídos aos Clientes.
 */
create table customer.gender(
	gender_id int identity(1,1) not null,
	gender_code char(10) not null,
	gender_description char(15) not null,
	primary key(gender_id)
);

/* ==============================
 * ========== Marital ===========
 * ==============================
 *
 * Tabela dedicada aos títulos de matrimonio atribuídos aos Clientes.
 */
create table customer.marital(
	marital_id int identity(1,1) not null,
	marital_code char(10) not null,
	marital_description char(15) not null,
	primary key(marital_id)
);

/* =================================
 * ========== Occupation ===========
 * =================================
 *
 * Tabela dedicada as ocupações atribuídas aos Clientes.
 */
create table customer.occupation(
	occupation_id int identity(1,1) not null,
	occupation_name char(30) not null,
	primary key(occupation_id)
);

/* =================================
 * ========== Education ============
 * =================================
 *
 * Tabela dedicada ao nível de educação atribuído aos Clientes.
 */
create table customer.education(
	education_id int identity(1,1) not null,
	education_name char(30) not null,
	primary key(education_id)
);


/* =====================================
 * ========== Schema Security ==========
 * =====================================
 * 
 * Schema dedicado a todas as informações referentes ao Utilizador.
 */
go
create schema security;
go

/* ============================
 * ========== User ============
 * ============================
 *
 * Tabela dedicada a guardar a informação de um Cliente que é um Utilizador.
 */
create table security._user(
	user_email char(30) not null,
	user_password char(30) not null,
	primary key(user_email)
);

/* ================================
 * ========== Question ============
 * ================================
 *
 * Tabela dedicada a guardar a(s) questão(ões) de segurança para 
 * recuperação da palavra-passe.
 */
create table security.question(
	question_id int identity(1,1) not null,
	security_question char(200) not null,
	primary key(question_id)
);

-- userQuestion
create table security.userQuestion(
	_user_email char(30),
	question_id int,
	answer varchar(200)

	primary key(_user_email),
	foreign key(_user_email) references security._user(user_email),
	foreign key(question_id) references security.question(question_id)
);

--sentEmails
create table security.sentEmail(
	destinatary char(100) not null,
	_message nvarchar(max) not null,
	sentTime datetime default getdate(),
	primary key(destinatary, sentTime)
);

-- Erros
go
create schema error
go

-- errorLog
create table error.errorLog (
    ErrorID int identity(1,1) primary key,
    ErrorMessage nvarchar(4000),
    ErrorNumber int,
    ErrorSeverity int,
    UserName nvarchar(100),
    ErrorDateTime datetime default getdate()
);

/* =====================================
 * ========== Schema Territory ==========
 * =====================================
 * 
 * Schema dedicado a todas as informações referentes aos Territórios.
 */
go
create schema territory
go

/* =============================
 * ========== Group ============
 * =============================
 *
 * Tabela dedicada a guardar a informação dos Continentes de venda.
 */
create table territory._group(
	group_id int identity(1,1) not null,
	group_name char(20) not null,
	primary key(group_id)
);

/* ===============================
 * ========== Country ============
 * ===============================
 *
 * Tabela dedicada a guardar a informação dos Países de venda.
 */
create table territory.country(
	country_id int identity(1,1) not null,
	group_id int,
	country_name char(20) not null,
	country_code char(10) not null,
	primary key(country_id),
	foreign key(group_id) references territory._group(group_id)
);

/* ==============================
 * ========== Region ============
 * ==============================
 *
 * Tabela dedicada a guardar a informação das Regiões dos Países.
 */
create table territory.region(
	region_id int identity(1,1) not null,
	country_id int,
	region_name char(20) not null,
	primary key(region_id),
	foreign key(country_id) references territory.country(country_id)
);

/* =============================
 * ========== State ============
 * =============================
 *
 * Tabela dedicada a guardar a informação dos Estatos das Regiões.
 */
create table territory._state(
	state_id int identity(1,1) not null,
	region_id int,
	state_name char(20) not null,
	state_code char(10) not null,
	primary key(state_id, region_id),
	foreign key(region_id) references territory.region(region_id)
);

/* ============================
 * ========== City ============
 * ============================
 *
 * Tabela dedicada a guardar a informação das Cidades dos Estados.
 */
create table territory.city(
	city_id int identity(1,1) not null,
	state_id int,
	region_id int,
	city_name char(50) not null,
	postal_code varchar(20) not null,
	primary key(city_id, state_id, region_id),
	foreign key(state_id, region_id) references territory._state(state_id, region_id)
);

/* ================================
 * ========== Customer ============
 * ================================
 *
 * Tabela dedicada a guardar a informação dos Clientes. 
 */
create table customer.customer(
	customer_id int not null,
	first_name char(30) not null,
	middle_name char(30),
	last_name char(30) not null,
	email varchar(300) not null,
	customer_address varchar(200) not null,
	customer_phone varchar(30) not null,
	yearly_income int not null,
	cars_owned int not null,
	birth_date date not null,
	first_purchase date not null,
	primary key(customer_id)
);

-- customerEducation
create table customer.customerEducation(
	customer_id int,
	education_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(education_id) references customer.education(education_id)
);

-- customerGender
create table customer.customerGender(
	customer_id int,
	gender_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(gender_id) references customer.gender(gender_id)
);

-- customerMarital
create table customer.customerMarital(
	customer_id int,
	marital_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(marital_id) references customer.marital(marital_id)
);

-- customerOccupation
create table customer.customerOccupation(
	customer_id int,
	occupation_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(occupation_id) references customer.occupation(occupation_id)
);

-- customerCity
create table customer.customerCity(
	customer_id int,
	city_id int,
	state_id int,
	region_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(city_id, state_id, region_id) references territory.city(city_id, state_id, region_id)
);

-- customerUser
create table customer.customerUser(
	customer_id int,
	_user_email char(30),
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(_user_email) references security._user(user_email)
);


/* ======================================
 * ========== Customer Title ============
 * ======================================
 *
 * Tabela dedicada a guardar a informação de Clientes que tem títulos atribuídos.
 */
create table customer.customerTitle(
	customer_id int,
	title_id int,
	primary key(customer_id),
	foreign key(customer_id) references customer.customer(customer_id),
	foreign key(title_id) references customer.title(title_id)
);

/* =====================================
 * ========== Schema Currency ==========
 * =====================================
 * 
 * Schema dedicado a todas as informações referentes as Moedas mundiais.
 */
go
create schema currency
go

/* ================================
 * ========== Currency ============
 * ================================
 *
 * Tabela dedicada a guardar a informação das Moedas.
 */
create table currency.currency(
	currency_id int identity(1,1) primary key,
	currency_name varchar(40) not null,
	currency_code char(10) not null
);

/* =====================================
 * ========== Schema Product ==========
 * =====================================
 * 
 * Schema dedicado a todas as informações referentes aos Produtos.
 */
go
create schema product
go

/* =============================
 * ========== Class ============
 * =============================
 *
 * Tabela dedicada a guardar a informação das Classes dos Produtos.
 */
create table product.class (
	class_id int identity(1,1) primary key,
	class_code varchar(10) not null
);

/* =============================
 * ========== Model ============
 * =============================
 *
 * Tabela dedicada a guardar a informação dos Modelos dos Produtos.
 */
create table product.model (
	model_id int identity(1,1) primary key,
	model_name varchar(100) not null
);

/* ============================
 * ========== Line ============
 * ============================
 *
 * Tabela dedicada a guardar a informação das Linhas de Produto.
 */
create table product.line (
	line_id int identity(1,1) primary key,
	line_code varchar(10) not null
);

/* =============================
 * ========== Style ============
 * =============================
 *
 * Tabela dedicada a guardar a informação dos Estilos dos Produtos.
 */
create table product.style (
	style_id int identity(1,1) primary key,
	style_code varchar(10) not null
);

/* ==================================
 * ========== Size Range ============
 * ==================================
 *
 * Tabela dedicada a guardar a informação dos Intervalos de Tamanho(?) dos Produtos.
 */
create table product.sizeRange (
	sizeRange_id int identity(1,1) primary key,
	sizeRange_description varchar(100) not null
);

/* ================================
 * ========== Category ============
 * ================================
 *
 * Tabela dedicada a guardar a informação das Categorias dos Produtos.
 */
create table product.category (
	category_id int identity(1,1) primary key,
	category_name varchar(100) not null,
	category_parentCategory int 
	foreign key (category_parentCategory) references product.category(category_id) 
		on delete no action 
		on update no action
);

/* =============================
 * ========== Color ============
 * =============================
 *
 * Tabela dedicada a guardar a informação das Cores dos Produtos.
 */
create table product.color (
	color_id int identity(1,1) primary key,
	color_name varchar(100) not null
);

/* =================================
 * ========== Size Unit ============
 * =================================
 *
 * Tabela dedicada a guardar a informação das Unidades de medida dos tamanhos dos Produtos.
 */
create table product.sizeUnit(
	sizeUnit_id int identity(1,1) primary key,
	sizeUnit_description varchar(10) not null
);

/* ===================================
 * ========== Weight Unit ============
 * ===================================
 *
 * Tabela dedicada a guardar a informação das Unidades de medida dos pesos dos Produtos.
 */
create table product.weigthUnit(
	weigthUnit_id int identity(1,1) primary key,
	weigthUnit_description varchar(10) not null
);

/* ===============================
 * ========== Product ============
 * ===============================
 *
 * Tabela dedicada a guardar a informação dos Produtos.
 */
create table product._product(
	product_id int primary key,
	product_name nvarchar(510) not null,
	product_description nvarchar(510) not null,
	product_dealerPrice float,
	product_listPrice float,
	product_daysToManufacture float not null, 
	product_standardCost float,
	product_finishedGoods bit,
	product_size varchar(10),
	product_weight float	
);

/* ==========================================
 * ========== Product Size Range ============
 * ==========================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Intervalos de Tamamho atribuídos.
 */
create table product.productSizeRange(
	product_id int,
	sizeRange_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(sizeRange_id) references product.sizeRange(sizeRange_id)
);

/* =====================================
 * ========== Product Style ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Estilos atribuídos.
 */
 create table product.productStyle(
	product_id int,
	style_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key (style_id) references product.style(style_id)
);

/* ====================================
 * ========== Product Line ============
 * ====================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Linhas de produto atribuídas.
 */
create table product.productLine(
	product_id int,
	line_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key (line_id) references product.line(line_id)
);

/* =========================================
 * ========== Product Size Unit ============
 * =========================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Unidades de medida(tamanho) atribuídas.
 */
create table product.productSizeUnit(
	product_id int,
	sizeUnit_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(sizeUnit_id) references product.sizeUnit(sizeUnit_id),
);

/* ===========================================
 * ========== Product Weight Unit ============
 * ===========================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Unidades de medida(peso) atribuídas.
 */
create table product.productWeigthUnit(
	product_id int,
	weigthUnit_id int,

	primary key (product_id),
	foreign key (product_id) references product._product(product_id),
	foreign key(weigthUnit_id) references product.weigthUnit(weigthUnit_id)
);

/* =====================================
 * ========== Product Color ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Cores atribuídas.
 */
create table product.productColor(
	product_id int,
	color_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(color_id) references product.color(color_id)
);

/* =====================================
 * ========== Product Model ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Modelos atribuídos.
 */
create table product.productModel(
	product_id int,
	model_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(model_id) references product.model(model_id),
);

/* =====================================
 * ========== Product Class ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Classes atribuídas.
 */
create table product.productClass(
	product_id int,
	class_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(class_id) references product.class(class_id),
);

/* ========================================
 * ========== Product Category ============
 * ========================================
 *
 * Tabela dedicada a guardar a informação de Produtos que tem Categorias atribuídas.
 */
create table product.productCategory(
	product_id int,
	category_id int,

	primary key(product_id),
	foreign key(product_id) references product._product(product_id),
	foreign key(category_id) references product.category(category_id)
);

/* ==================================
 * ========== Schema Sales ==========
 * ==================================
 * 
 * Schema dedicado a todas as informações referentes as Vendas.
 */
go
create schema sales
go

/* =====================================
 * ========== Sales ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação das Vendas.
 */
create table sales.sale(
	sales_id varchar(20),
	sales_lineNumber int not null,
	sales_quantity int not null,
	sales_unitPrice float not null,
	sales_taxAmount float not null,
	sales_freight float not null,
	sales_dueDate date not null,
	sales_orderDate date not null,
	sales_shipDate date not null,

	primary key(sales_id, sales_lineNumber)
);

/* =====================================
 * ========== Product Sales ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação relacionada dos Produtos as Vendas.
 */
create table sales.saleProducts(
	sales_id varchar(20),
	sales_lineNumber int,
	product_id int,
	primary key(sales_id, sales_lineNumber, product_id),
	foreign key(sales_id, sales_lineNumber) references sales.sale(sales_id, sales_lineNumber),
	foreign key(product_id) references product._product(product_id)
);

/* ======================================
 * ========== Sales Currency ============
 * ======================================
 *
 * Tabela dedicada a guardar a informação relacionada das Moedas as Vendas.
 */

 create table sales.saleCurrency(
	sales_id varchar(20),
	sales_lineNumber int,
	currency_id int,
	primary key(sales_id, sales_lineNumber, currency_id),
	foreign key(sales_id, sales_lineNumber) references sales.sale(sales_id, sales_lineNumber),
	foreign key(currency_id) references currency.currency(currency_id)
 );

/* =====================================
 * ========== Sales Country ============
 * =====================================
 *
 * Tabela dedicada a guardar a informação relacionada dos Países as Vendas.
 */

 create table sales.saleCountry(
	sales_id varchar(20),
	sales_lineNumber int,
	country_id int,
	primary key(sales_id, sales_lineNumber, country_id),
	foreign key(sales_id, sales_lineNumber) references sales.sale(sales_id, sales_lineNumber),
	foreign key(country_id) references territory.country(country_id)
 );

/* ======================================
 * ========== Sales Customer ============
 * ======================================
 *
 * Tabela dedicada a guardar a informação relacionada dos Clientes as Vendas.
 */
 create table sales.saleCustomer(
	sales_id varchar(20),
	sales_lineNumber int,
	customer_id int,
	primary key(sales_id, sales_lineNumber, customer_id),
	foreign key(sales_id, sales_lineNumber) references sales.sale(sales_id, sales_lineNumber),
	foreign key(customer_id) references customer.customer(customer_id)
 );