-- Populate tables --
use AdventureWorksBetter;
-- Table Title --
-- Why? beacause it too much simple
select * from title;
select distinct c.Gender from AdventureWorksLegacy.dbo.Customer$ c;

insert into title(title_description)
select distinct Title from AdventureWorksLegacy.dbo.Customer$ c
where c.Title != '';

-- ja está essa poha

-- Table Gender --
-- Why? I don't KNOW!
select * from gender;
