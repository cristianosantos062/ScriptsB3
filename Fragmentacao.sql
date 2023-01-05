USE BANCO
GO
declare   @objctID INT = NULL --= OBJECT_ID('ADM_BDADOS.dbo.TB_PROCESS_DETAIL'), 
		, @dbID INT = db_id()

select 
		DB_NAME(ips.database_id) dbname, 
		OBJECT_NAME(ips.object_id) objectname,
		si.indid,
		si.name, 
		ips.index_type_desc, 
		ips.avg_fragmentation_in_percent, 
		ips.avg_fragment_size_in_pages, 
		cast (ips.page_count*8/1024 as decimal(12,0)) size_MB
	from master.sys.dm_db_index_physical_stats(@dbID, @objctID, NULL, NULL, NULL) ips
		join sysindexes si
			on ips.object_id = si.id and ips.index_id = si.indid
	order by 8 desc

