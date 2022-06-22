IF NOT EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'_Sys_Index_Stats_Maintenance')
BEGIN
	BEGIN TRANSACTION
    DECLARE @ReturnCode INT
    SELECT @ReturnCode = 0
    IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
    BEGIN
    EXEC @ReturnCode = dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

    END

    DECLARE @jobId BINARY(16)
    EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'_Sys_Index_Stats_Maintenance',
        @enabled = 1,
        @notify_level_eventlog=0,
        @notify_level_email=0,
        @notify_level_netsend=0,
        @notify_level_page=0,
        @delete_level=0,
        @category_name=N'Database Maintenance',
        @job_id = @jobId OUTPUT
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'_Maintenance Index & Statistics',
        @step_id=1,
        @cmdexec_success_code=0,
        @on_success_action=1,
        @on_success_step_id=0,
        @on_fail_action=2,
        @on_fail_step_id=0,
        @retry_attempts=0,
        @retry_interval=0,
        @os_run_priority=0,
        @subsystem=N'TSQL',
        @command=N'DELETE FROM [XsuntAdmin].[dbo].[_Sys_Index_Maintenance_Log]
    WHERE [EndTime] < GETDATE()-30;
    GO
    EXECUTE [XsuntAdmin].dbo._Sys_Index_Maintenance
    @Databases = ''USER_DATABASES,-rdsadmin'',
    @FragmentationLow = NULL,
    @FragmentationMedium = ''INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'',
    @FragmentationHigh = ''INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'',
    @FragmentationLowLevel = 5,
    @FragmentationHighLevel = 30,
    @PageCountLevel = 0,
    @FillFactor = 80,
    @UpdateStatistics = ''ALL'',
    @OnlyModifiedStatistics = ''Y'',
    @StatisticsSample = 100,
    @LogToTable = ''Y'',
    @Execute = ''Y'';
    GO',
        @database_name=N'master',
        @flags=0
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'_Maintenance Index & Statistics',
        @enabled=1,
        @freq_type = 8,
        @freq_interval = 1,
        @freq_subday_type = 1,
        @freq_subday_interval = 0,
        @freq_relative_interval = 0,
        @freq_recurrence_factor = 1,
        @active_start_date = 20180101,
        @active_end_date = 99991231,
        @active_start_time = 90001,
        @active_end_time = 235959
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
    IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
    COMMIT TRANSACTION
    GOTO EndSave
    QuitWithRollback:
	IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
	EndSave:
END
