use master
go
-- Informações no chache de uma determinada Store Procedure
select 
*
 from sys.dm_exec_procedure_stats es
  cross apply sys.dm_exec_query_plan(es.plan_handle) ep
where 
OBJECT_NAME(es.object_id, es.database_id)='TempGetStateItemExclusive3'