
SELECT
	DB_NAME(A.database_id) 'dbname',
	SCHEMA_NAME(C.[schema_id]) 'schname',
	OBJECT_NAME(A.object_id) 'objname',
	A.index_id,
	B.name,
	E.partition_number,
	A.avg_fragmentation_in_percent,
	((B.used*8)/1024) as 'Usado',
	E.rows as 'NroLinhas'
FROM
	sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED')AS A
	INNER JOIN sys.sysindexes AS B ON A.object_id = B.id AND A.index_id = B.indid
	INNER JOIN sys.objects AS C ON A.object_id = C.object_id
	INNER JOIN sys.partitions AS E ON A.object_id = E.object_id and A.index_id = E.index_id
WHERE
	A.index_id > 0
AND A.avg_fragmentation_in_percent > 10
--AND A.avg_fragmentation_in_percent between 10 and 30 --Reorganize
--AND A.avg_fragmentation_in_percent > 30      --Rebuild
ORDER BY
	A.avg_fragmentation_in_percent DESC
GO


--------------------------------------------------------------------------------------



SELECT
	DB_NAME(A.database_id) as dbname,
	SCHEMA_NAME(C.[schema_id]) as schname,
	OBJECT_NAME(A.[object_id]) as objname,
	A.index_id,
	B.name,
	B.type_desc,
	B.fill_factor,
	D.[rows],
	SUM(A.avg_fragmentation_in_percent) as avg_fragmentation_in_percent,
	AVG((E.total_pages * 8) / 1024) as totalSpaceMB
FROM
	sys.dm_db_index_physical_stats (DB_ID(), object_id('TBOK2_CBRRECEITA_LOG'), NULL, NULL, 'LIMITED')AS A
	INNER JOIN sys.indexes AS B ON A.object_id = B.object_id AND A.index_id = B.index_id
	INNER JOIN sys.objects AS C ON A.object_id = C.object_id
	INNER JOIN sys.partitions D ON D.[object_id] = C.[object_id] AND D.index_id = B.index_id
	INNER JOIN (SELECT container_id, SUM(total_pages) as total_pages FROM sys.allocation_units GROUP BY container_id) as E ON E.container_id = D.partition_id
--WHERE
--	A.index_id > 0 --Exclui o HEAP
--AND A.avg_fragmentation_in_percent > 10
--AND A.avg_fragmentation_in_percent between 10 and 30 --Reorganize
--AND A.avg_fragmentation_in_percent > 30      --Rebuild
GROUP BY
	DB_NAME(A.database_id),
	SCHEMA_NAME(C.[schema_id]),
	OBJECT_NAME(A.[object_id]),
	A.index_id,
	B.name,
	B.type_desc,
	B.fill_factor,
	D.[rows]
ORDER BY
	3 ASC,
	4 ASC
GO



----------------------------------------------------------------------------------------------------------------------------------------



SELECT
	'alter index '+B.name+' on ['+SCHEMA_NAME(A.[schema_id])+'].['+OBJECT_NAME(B.object_id)+'] rebuild;'
FROM
sys.objects A
INNER JOIN sys.indexes AS B ON A.object_id = B.object_id
WHERE A.type='U' AND B.type > 0
ORDER BY OBJECT_NAME(B.object_id) ASC