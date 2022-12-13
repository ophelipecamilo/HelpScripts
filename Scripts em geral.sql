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


---- INSERT ADM DO SISTEMA - PERFIL ADM CÓDIGO 1848

INSERT INTO USUARIO_PERFIL
(CD_PERFIL,DS_OBSERVACAO,DS_UTC,DS_UTC_ATUALIZACAO,DT_ATUALIZACAO,DT_LIBERACAO,DT_VALIDADE,IE_HORARIO_VERAO,NM_USUARIO,NM_USUARIO_ATUAL,NR_SEQ_APRES,NR_SEQUENCIA)
VALUES (1848,null,'07/04/2022T08:39:55-03:00','07/04/2022T08:39:55-03:00',sysdate,sysdate,null,'N','NOME_USUARIO','NOME_USUARIO',1,USUARIO_PERFIL_SEQ.nextval)
;
commit;


--- Pesquisar Parametro pela funcao/descricao
select
b.cd_funcao,
OBTER_DESC_FUNCAO(b.cd_funcao) as funcao,
a.NR_SEQUENCIA,
a.DS_PARAMETRO as parametro,
a.vl_parametro_padrao as padrao_sistema,
a.vl_parametro as padrao_cliente

from FUNCAO_PARAMETRO A, FUNCAO B

where b.cd_funcao = a.cd_funcao

and A.DS_PARAMETRO like '%campo%'
and B.DS_FUNCAO like '%CPOE%'
--and a.nr_sequencia = 131




-------- Extrair estrutura de atendimento --------

--Somente setor
select
substr(obter_valor_dominio(1, a.CD_CLASSIF_SETOR),1,200) CLASSIFICACAO,
a.ds_SETOR_ATENDIMENTO as SETOR_PRINCIPAL,
obter_desc_local_estoque(a.CD_LOCAL_ESTOQUE) ESTOQUE,
decode(a.IE_OCUP_HOSPITALAR, 'N', 'Não mostrar', 'M', 'Mostrar', 'S', 'Mostrar e totalizar', 'T', 'Mostrar e não totalizar', IE_OCUP_HOSPITALAR) OCUPACAO,
decode(IE_ADEP , 'N', 'Não', 'S', 'Sim (com gestão de horários)', 'P', 'Sim (sem gestão de horários)', IE_ADEP ) ADEP,
decode(IE_MOSTRA_GESTAO_NUTRICAO , 'S', 'Sim', 'N', 'Não', IE_MOSTRA_GESTAO_NUTRICAO) NUTRICAO,
decode(IE_ENFERMAGEM_FARM, 'S', 'Sim', 'N', 'Não', IE_ENFERMAGEM_FARM) GPT,
decode(IE_MOSTRA_PACIENTE, 'N', 'Não', 'S', 'Sim', 'E', 'Somente EUP', 'M', 'Somente Movimentação') MOVIMENTA
from SETOR_ATENDIMENTO A
where CD_ESTABELECIMENTO = :ESTABELECIMENTO
and a.IE_SITUACAO = 'A'
order by 1,2


--Setor-leito
select
substr(obter_valor_dominio(1, a.CD_CLASSIF_SETOR),1,200) CLASSIFICACAO,
a.ds_SETOR_ATENDIMENTO as SETOR_PRINCIPAL,
b.CD_UNIDADE_BASICA as LEITO,
b.CD_UNIDADE_COMPL as COMPLEMENTO,
c.DS_TIPO_ACOMODACAO,
substr(obter_valor_dominio(82, b.IE_STATUS_UNIDADE),1,200) as STATUS,
decode(b.IE_SITUACAO, 'A', 'Leito ativo', b.IE_SITUACAO) as SITUACAO_LEITO
from SETOR_ATENDIMENTO A,
	UNIDADE_ATENDIMENTO B,
	TIPO_ACOMODACAO C
where CD_ESTABELECIMENTO = :ESTABELECIMENTO
and b.cd_setor_atendimento(+) = a.cd_setor_atendimento
and b.CD_TIPO_ACOMODACAO = c.CD_TIPO_ACOMODACAO(+)
and a.IE_SITUACAO = 'A'
and :TIPO_REL = 2
and (a.CD_CLASSIF_SETOR = :CLASSIF or :CLASSIF = 0) 
order by 1,2,3,4

-------- Fim extrair estrutura de atendimento --------