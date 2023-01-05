SELECT 
	@@SERVERNAME Inst�ncia,
	COUNT([HOST_NAME]) QTDE_Conex�es,  
	[HOST_NAME] Hostname, 
	host_process_id PID_Windows, 
	GETDATE() Data_Coleta
FROM sys.dm_exec_sessions 
where host_process_id >0
GROUP BY [HOST_NAME], host_process_id
order by 2 desc


-- Retorna a Quantidade de conex�es por HOSTName,PID do Windows e Program_Name. 
-- Facilita a analise Durante incidente quando uma aplica��o esta tomando erro que atingiu o m�ximo de conex�es
Use master
go
Select CAST(@@SERVERNAME as VarCHar(20)) as Instancia, 
      COUNT(*) as QTDE_Conex�es, 
      DB_NAME(dbid) AS Banco, 
      Cast(hostname as VarChar(25)) as HostName,
      hostprocess as PID_Windows,
      Cast(Program_Name as VarChar(25)) as Program_Name,
      GetDate() as Data_Colata
From sysprocesses 
Group By hostname ,
      hostprocess, PROGRAM_NAME, DB_NAME(dbid)
Order By 2 desc
