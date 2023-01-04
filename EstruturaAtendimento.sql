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