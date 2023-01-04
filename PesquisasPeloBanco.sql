------------------------ Pesquisar Parametro pela funcao/descricao ------------------------
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


------------------------ Pesquisar Regra Consiste Prescricao ------------------------
select
a.ds_regra_prescr,
a.*
from REGRA_CONSISTE_PRESCR A
where a.ds_regra_prescr like '%hemoc%'



------------------------ Pesquisar Dominio ------------------------

select
a.CD_DOMINIO,
a.NM_DOMINIO,
a.ds_dominio,
a.ie_alterar,
b.vl_dominio,
b.ds_valor_dominio,
b.ds_valor_dominio_cliente,
b.ie_situacao
from DOMINIO A, VALOR_DOMINIO B
where a.CD_DOMINIO = b.CD_DOMINIO 
--and NM_DOMINIO like '%SUS%'
--and b.vl_dominio like '501'
and a.cd_dominio like '501'
--and b.ds_valor_dominio like '%Ele%'
--and b.ds_valor_dominio_cliente like '%Ele%'


------------------------ Pesquisar usuario medico pelo CRM ------------------------

select
b.CD_PESSOA_FISICA,
a.NM_USUARIO LOGIN,
a.DS_LOGIN LOGIN_ALTERNATIVO,
substr(obter_nome_pf(a.cd_pessoa_fisica),1,255) NOME_USUARIO,
b.NM_PESSOA_FISICA,
b.DS_CODIGO_PROF,
b.NR_CPF,
b.NR_IDENTIDADE,
c.NM_GUERRA,
c.NR_CRM,
a.IE_SITUACAO,
obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento) TIPO_AUT,
obter_valor_dominio(2071,obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento)) AUTENTICACAO_LOGIN,
OBTER_NOME_ESTAB(A.CD_ESTABELECIMENTO) ESTABELECIMENTO

from USUARIO A, PESSOA_FISICA B, MEDICO C

where a.cd_pessoa_fisica(+) = b.cd_pessoa_fisica
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and NR_CRM in ('CRM')

------------------------ Consultar Usuario por CPF ------------------------

select distinct
b.CD_PESSOA_FISICA,
a.NM_USUARIO LOGIN,
a.DS_LOGIN LOGIN_ALTERNATIVO,
A.DS_USUARIO NOME_USUARIO,
b.NM_PESSOA_FISICA,
b.DS_CODIGO_PROF,
b.NR_CPF,
b.NR_IDENTIDADE,
c.NM_GUERRA,
c.NR_CRM,
a.IE_SITUACAO SITUACAO_USUARIO,
c.IE_SITUACAO SITUACAO_MEDICO,
tasy.obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento) TIPO_AUT,
tasy.obter_valor_dominio(2071,tasy.obter_valor_param_usuario(0,87,0,a.nm_usuario,A.cd_estabelecimento)) AUTENTICACAO_LOGIN,
tasy.OBTER_NOME_ESTAB(A.CD_ESTABELECIMENTO) ESTAB_PRINCIPAL,
tasy.OBTER_NOME_ESTAB(D.CD_ESTABELECIMENTO) ESTAB_ADICIONAL
    
from tasy.USUARIO A, tasy.PESSOA_FISICA B, tasy.MEDICO C, tasy.USUARIO_ESTABELECIMENTO D, tasy.USUARIO_PERFIL E

where a.cd_pessoa_fisica(+) = b.cd_pessoa_fisica
and a.nm_usuario = d.nm_usuario_param(+)
and a.nm_usuario = e.nm_usuario(+)
and b.cd_pessoa_fisica = c.cd_pessoa_fisica(+)
and b.NR_CPF in ('15210417760')

order by 4

------------------------ Pesquisar tabela liberada para perfil ------------------------

select
obter_desc_perfil(cd_perfil),
a.*
from TABELA_SISTEMA_PERFIL A
where NM_TABELA = 'PARAMETRO_TESOURARIA'
order by 1

------------------------ Pesquisar função liberada para perfil ------------------------
select
obter_desc_perfil(a.cd_perfil) PERFIL,
OBTER_DESC_FUNCAO(b.cd_funcao) FUNCAO,
a.*
from FUNCAO_PERFIL A, FUNCAO B, PERFIL C
where B.DS_FUNCAO like '%Funcio%'
and a.cd_funcao = b.cd_funcao
and a.cd_perfil = c.cd_perfil
and c.ie_situacao = 'A'
order by 1


------------------------ Pesquisar atendimentos duplicados ------------------------

Select
NR_ATENDIMENTO,
substr(obter_nome_pf(t1.cd_pessoa_fisica),1,255) NOME_PESSOA,
to_char(t1.dt_entrada,'dd/mm/yyyy hh24:mi:ss') DATA_ENTRADA,
to_char(t1.dt_alta,'dd/mm/yyyy hh24:mi:ss') DATA_ALTA,
obter_nome_usuario(t1.nm_usuario_atend) USUARIO_ATEND
From atendimento_paciente t1
Where       exists (select dt_entrada, cd_pessoa_fisica
                    from atendimento_paciente t2
                    where t2.dt_entrada = t1.dt_entrada
                    and   t2.cd_pessoa_fisica = t1.cd_pessoa_fisica
                    and cd_estabelecimento = :cd_estabelecimento
                    group by dt_entrada, cd_pessoa_fisica 
                    having count(*) > 1)
                    order by t1.NR_ATENDIMENTO