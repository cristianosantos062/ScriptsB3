if exists (select name from tempdb.sys.objects where name like '%#p_spacelog%')
	drop procedure #p_spacelog
go
create procedure #p_spacelog (@dbname sysname = null)
as 
if exists (select name from tempdb.sys.objects where name like '%#t_tlog%')
	drop table #t_tlog

create table #t_tlog (DBName varchar(100), LogSize numeric(12,2), LogSpaceUsed_percent numeric(4,2), status int)

declare @text nvarchar (30) = 'dbcc sqlperf(logspace)'

insert #t_tlog exec sp_executesql @text

if @dbname is not null
begin 
	select * from #t_tlog where DBName = @dbname
end


if @dbname is  null
begin 
	select * from #t_tlog order by 3 desc
end

go

exec #p_spacelog 

