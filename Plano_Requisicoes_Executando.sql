select er.session_id,  
	db_name(er.database_id) database_id,
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

--where db_name(er.database_id) like 'dbav%'