
if exists (select name from tempdb..sysobjects where name like '%#t_verificalog%')
	drop table #t_verificalog 

create table #t_verificalog (   database_name varchar(50)
							  , logsize_MB numeric(12,2) 
							  , logspaceused_pct numeric(12,2) 
							  , status char (1)
							 )

declare @verificalog as nvarchar(50) = 'dbcc sqlperf(logspace)'
insert into #t_verificalog
		exec sp_executesql @verificalog

select a.*, b.recovery_model_desc from #t_verificalog a
	join sys.databases b on a.database_name = b.name
	where database_name = 'GMC'
order by 3 desc


sp_helpdb GMC

USE MASTER
GO
ALTER DATABASE GMC
MODIFY FILE (NAME = 'GMC_LOG_06', SIZE = 120000MB)


sp_Readerrorlog