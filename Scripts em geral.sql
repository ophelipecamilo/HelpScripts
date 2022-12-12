

-- Data/Hora banco

select to_char(sysdate,'dd/mm/yyyy hh24:mi:ss')from dual



-- GERANDO DATAS NO BANCO

select trunc(to_date(sysdate)) + (level-1) DIA_CALENDARIO, TO_CHAR(trunc(to_date(sysdate)) + (level-1),'D') DIA_SEMANA
from dual
connect BY level <= to_number(to_date(sysdate+30) - TO_DATE(sysdate)) + 1


select
-----------------------
-- TO_CHAR GERAL
------------------------
--DIA
to_char(SYSDATE, 'DD') DIA,
to_char(SYSDATE, 'DY') DIA_ABREVIADO,
to_char(SYSDATE, 'DAY') DIA_DESCRITO,
to_char(SYSDATE, 'DDD') DIA_DO_ANO, --1 até 366
-- MES
to_char(SYSDATE, 'MM') MES,
to_char(SYSDATE, 'MON') MES_ABREVIADO,
to_char(SYSDATE, 'MONTH') MES_DESCRITO,
to_char(SYSDATE, 'RM') MES_ROMANOS,
-- ANO
to_char(SYSDATE, 'YYYY') ANO,
to_char(SYSDATE, 'YEAR') ANO_DESCRITO,
to_char(SYSDATE, 'DD/MM/YYYY') DIA_MES_ANO,
-- SEMANA
to_char(SYSDATE, 'W') SEMANA_MES,
to_char(SYSDATE, 'WW') SEMANA_ANO,
-- HORAS
to_char(SYSDATE, 'HH24') HORA_24,
to_char(SYSDATE, 'HH12') HORA12,
to_char(SYSDATE, 'HH24:MI') HORA_MINUTO,
to_char(SYSDATE, 'HH:MI:SS') HORA_MINUTO_SEGUNDO,
to_char(SYSDATE, 'HH:MI:SS:SSSSS') HORA_M_S_MILESEGUNDO,
-- DATA d.C.
to_char(SYSDATE, 'DD/MM/YYYY HH:MI:SS ad') COMPLETO_D_C,
to_char(sysdate,'DD "de" MONTH "de" YYYY') as EXEMPLO,
-- Converter numero em string
to_char(11100.1,'999,999.99') NUM_STRING
from dual


