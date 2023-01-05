use master
go
      select      req.session_id,
                  blocking_session_id,    
                  db_name(req.database_id) dbname,
				   OBJECT_NAME(st.objectid,req.database_id) [object_name],
                  ses.login_time,
                  ses.last_request_end_time,                
                  case convert(varchar(20), getdate() - req.start_time, 108) 
                        when '23:59:59' then '00:00:00'
                        else convert(varchar(20), getdate() - req.start_time, 108)
                  end as total_time,                  
                  req.cpu_time,
				  req.reads,
                  req.writes,
                  req.logical_reads,
				  req.wait_time,
                  req.wait_type,
                  req.wait_resource,
                  mmg.dop as QueryDOP,                
                  (select COUNT(*) from sys.dm_os_tasks tsk2 where tsk2.session_id = req.session_id) as taskcount,                         
                  mmg.query_cost,
				  (select query_plan from sys.dm_exec_query_plan (req.plan_handle)) as query_plan,
				  mmg.requested_memory_kb,
                  (SELECT SUBSTRING(st.text,req.statement_start_offset/2,(CASE WHEN req.statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE req.statement_end_offset end -req.statement_start_offset)/2) FROM sys.dm_exec_sql_text(req.sql_handle)) [actual_text], 
                  --(select text from sys.dm_exec_sql_text (req.sql_handle)) [complete_text], 
                  ses.host_name,
                  ses.login_name,
                  req.status,
                  req.command,
                  req.last_wait_type,
                  --(SELECT SUBSTRING(text,req.statement_start_offset/2,(CASE WHEN req.statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE req.statement_end_offset end -req.statement_start_offset)/2) FROM sys.dm_exec_sql_text(req.sql_handle)) [actual_text],
                  ses.program_name, 
                  req.start_time, 
                  req.status,
                  req.command,            
                  ses.last_request_start_time,
                  ses.last_request_end_time,
                  ses.login_name,
                  req.open_transaction_count,
                  req.open_resultset_count,
                  req.percent_complete,
                  req.estimated_completion_time,
				  req.plan_handle
                  from sys.dm_exec_requests req with(nolock)
				    CROSS APPLY sys.dm_exec_sql_text (req.sql_handle) st
				  inner join sys.dm_exec_sessions ses with(nolock)
                              on req.session_id = ses.session_id
                        left join sys.dm_exec_query_memory_grants mmg with(nolock)
                              on req.session_id = mmg.session_id
                  where 
                        ses.session_id > 50 and ses.session_id <> @@SPID
						and db_name(req.database_id) = 'TESOURO'
                       order by 7 desc, 9 desc	--req.cpu_time desc

					   -- SPTD_CO_CONTNG_CRTD
					   -- SPTD_UP_LIM_OPRC_TITU

					   -- SPTD_CO_INVESTIDOR_POPUP -- 00:00:36


select er.session_id,
	db_name(er.database_id) dbname,
       st.text as TSQLCompleto,
       qp.query_plan as PlanoCompleto,
       SubsTring(st.text,er.statement_start_offset/2, (Case When er.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2
                                                                                                                  ELSE er.statement_end_offset
                                                                                                                  END
       - er.statement_start_offset)/2) as TrechoQueryEmExecusao,
       --tpq.query_plan as TrechoPlanoEmExecusao
       CAST(tpq.query_plan as XML) as TrechoPlanoEmExecusao
from sys.dm_exec_requests er
	Cross apply sys.dm_exec_text_query_plan(er.plan_handle, er.statement_start_offset , er.statement_end_offset) tpq
	Cross apply sys.dm_exec_query_plan (er.plan_handle) qp
	Cross Apply sys.dm_exec_sql_text (er.sql_handle) st
where er.session_id > 50
   and db_name(er.database_id) = 'TESOURO'


   

use ADM_BDADOS
go
select * from TB_PROCESS_DETAIL where collection_time > '2022-01-03 17:00:00.000'
and database_name = 'TESOURO'
order by collection_time desc

-- SPTD_CO_CONTNG_CRTD
-- SPTD_UP_TRATA_CRTD
-- SPTD_UP_LIM_OPRC_TITU

SP_READERRORLOG

