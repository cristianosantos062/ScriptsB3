	if exists (select name from tempdb.sys.objects where name like '#tb_espaco%')
		drop table #tb_espaco

			SELECT DISTINCT @@SERVERNAME server,
				VS.volume_mount_point [Montagem] ,
				VS.logical_volume_name AS [Volume] ,
				CASE 
					WHEN logical_volume_name LIKE '%TEMPBD_DADOS%' THEN 'TEMPDB_Dados'
					WHEN logical_volume_name LIKE '%TEMPBD_LOG%' THEN 'TEMPDB_log'
					WHEN logical_volume_name LIKE '%TEMPDB%' THEN 'TEMPDB'
					WHEN logical_volume_name LIKE '%DADOS%' THEN 'Dados'
					WHEN logical_volume_name LIKE '%DATA%' THEN 'Dados'
					WHEN logical_volume_name LIKE '%LOG%' THEN 'LOG'
					ELSE 'N/A'
				END Tipo,
				CAST(CAST(VS.total_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Total (GB)] ,
				CAST(CAST(VS.available_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Espaço Disponível (GB)] ,
				CAST(( CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço Disponível ( % )] ,
				CAST(( 100 - CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço em uso ( % )]
			into #tb_espaco
			FROM
				sys.master_files AS MF
				CROSS APPLY [sys].[dm_os_volume_stats](MF.database_id, MF.file_id) AS VS
			WHERE
				CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 < 100 ORDER BY 5 DESC

	select * from #tb_espaco where Montagem like '%E:\SQLPOS022CP_E_LOG02%'
	--where Tipo = 'LOG'
	--where Montagem in
	--(	  'G:\SQLHSTCORPEP_G_DADOS12\'
	--)
	order by 6 desc



select db_name(database_id) dbname, name,  type_desc, physical_name, size*8/1024 size_MB, growth 
from sys.master_files
where db_name(database_id) = 'GMC' 
	and type_desc = 'LOG'


exec [master].[dbo].[sp_analyse_files_ex] 'E:\SQLPOS022CP_E_LOG\'
exec [master].[dbo].[sp_analyse_files_ex] 'F:\SQLHSTCORPEP_F_LOG\'
exec [master].[dbo].[sp_analyse_files_ex] 'N:\SQLSINFEP_N_Dados02\'
exec [master].[dbo].[sp_analyse_files_ex] 'L:\SQLSINFEP_L_DADOS08\'

select * from sys.dm_os_cluster_nodes
	

select @@SERVERNAME Instancia,
	  Tipo
	, SUM([Total (GB)]) [Total (GB)]
	, SUM([Total (GB)]-[Espaço Disponível (GB)]) [Espaço Utilizado (GB)]
	, SUM([Espaço Disponível (GB)]) [Disponivel (GB)]
	, cast (100*SUM([Espaço Disponível (GB)])/SUM([Total (GB)]) as numeric(12,2)) [Espaço Disponível ( % )]
	from #tb_espaco
GROUP BY Tipo



select db_name(database_id) dbname, 'ALTER DATABASE ['+ db_name(database_id) + '] MODIFY FILE ( NAME = N''' + name + ''', FILEGROWTH = 0)', type_desc, size*8/1024 size_MB, growth, physical_name   
from sys.master_files 
where physical_name like 'G:\%' and growth > 0
	--and db_name(database_id) = 'EASYSPED' 
order by 4 desc

select db_name(database_id) dbname, name,  type_desc, physical_name, /*cast (size*8/1024 as bigint),*/ growth 
from sys.master_files
where db_name(database_id) = 'wslogdb70' and type_desc = 'ROWS'
order by growth desc



ALTER DATABASE [PWDS] MODIFY FILE ( NAME = N'PWDS_02', FILEGROWTH = 0)

alter database STGTD set recovery full 
USE [master]
GO
ALTER DATABASE [HTD] MODIFY FILE ( NAME = N'HTD_data_24', FILEGROWTH = 131072KB )
GO
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_Data55', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW43', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_Data59', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_data66', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_data70', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_data67', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_Data9', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW_Data30', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW66', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW67', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW68', FILEGROWTH = 0)
ALTER DATABASE [SI_DW] MODIFY FILE ( NAME = N'SI_DW77', FILEGROWTH = 0)
ALTER DATABASE [HTD]   MODIFY FILE ( NAME = N'HTD_data_22', FILEGROWTH = 0)