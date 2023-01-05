select 
	DB_NAME(er.database_id) dbname, 
	er.session_id, er.status,
	er.blocking_session_id BlkBy,
	er.wait_type,
	er.percent_complete,
	er.estimated_completion_time/60000 estimated_time_min,
	es.host_name,	
	es.login_name,
	er.start_time,
	er.wait_time,
	er.total_elapsed_time/60000 elapsed_time,
	er.command,
			
	SubsTring(st.text,er.statement_start_offset/2, (Case When er.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
                                                                                                                  ELSE er.statement_end_offset
                                                                                                                  END 
       - er.statement_start_offset)/2) as TrechoQueryEmExecusao

from sys.dm_exec_requests er
Cross Apply sys.dm_exec_sql_text (er.sql_handle) st
Join sys.dm_exec_sessions es
on er.session_id = es.session_id
where er.percent_complete > 0
go
select session_id, blocking_session_id from sys.dm_exec_requests where blocking_session_id	> 0