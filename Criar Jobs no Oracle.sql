-- SEMPRE INSIRA O NOME DO SCHEMA ANTES DO NOME DO JOB... EXEMPLO: TASY.NOME_JOB
-- CREATE JOB
alter session set current_schema=tasy;
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
            job_name => 'NOME_DO_JOB_AQUI',
            job_type => 'PLSQL_BLOCK',
            job_action => 'GERAR_ALTA_AUTOMATICA;',
            number_of_arguments => 0,
            start_date => TO_TIMESTAMP_TZ('2022-03-26 01:00:00.000000000 AMERICA/SAO_PAULO','YYYY-MM-DD HH24:MI:SS.FF TZR'),
            repeat_interval => 'freq=daily; byhour=23; byminute=50; bysecond=0;', -- INTERVALO 1 VEZ AO DIA no horário 23:50
            end_date => NULL, 
            enabled => FALSE,
            auto_drop => TRUE,
            comments => '');   

    DBMS_SCHEDULER.SET_ATTRIBUTE( 
             name => 'NOME_DO_JOB_AQUI', 
             attribute => 'logging_level', value => DBMS_SCHEDULER.LOGGING_RUNS);
  
    DBMS_SCHEDULER.enable(
             name => 'NOME_DO_JOB_AQUI');
END;
/



-- NOTIFICACAO OPCIONAL
BEGIN
DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
job_name => 'NOME_DO_JOB_AQUI',
recipients => 'destinatario@teste.com.br',
sender => 'remetente@teste.com.br',
subject => 'TASYPRD - Job Notification-%job_owner%.%job_name%-%event_type%',
body => '%event_type% occured on %event_timestamp%. %error_message%',
events => 'JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_STOPPED' );
END;
/