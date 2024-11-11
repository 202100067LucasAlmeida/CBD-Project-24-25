-- Populate tables --
use AdventureWorksBetter;
-- Table Title --
-- Why? beacause it too much simple
select * from title;
select distinct Title from AdventureWorksLegacy.dbo.Customer$;

insert into title(title_description)
select distinct Title from AdventureWorksLegacy.dbo.Customer$ c
where c.Title != '';