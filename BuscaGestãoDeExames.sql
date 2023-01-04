
-- GESTAO de EXAMES

select distinct
obter_descricao_padrao('PROC_INTERNO_CLASSIF','DS_CLASSIFICACAO', PR.NR_SEQ_CLASSIF) CLASSIFICACAO,
obter_dados_pf(b.cd_pessoa_fisica, 'NA') PESSOA,
a.DT_NASCIMENTO,
a.DS_SEXO,
PR.CD_PROCEDIMENTO_TUSS TUSS,
coalesce(EX.NM_EXAME, obter_desc_proc_interno(d.NR_SEQ_PROC_INTERNO)) PROC_EXAME,
d.qt_procedimento QT,
coalesce(obter_desc_material_exame_lab(d.CD_MATERIAL_EXAME),substr(obter_descricao_padrao('PROC_INTERNO_CONTRASTE', 'DS_CONTRASTE', d.nr_seq_contraste),1,150)) MATERIAL,
SUBSTR(obter_valor_dominio(1226,IE_STATUS_EXECUCAO),1,255) STATUS,
d.DT_PREV_EXECUCAO DT_PREV_EXECUCAO,
obter_descricao_padrao('INTERVALO_PRESCRICAO','DS_PRESCRICAO', CD_INTERVALO) || ' - ' || d.DS_HORARIOS INTERVALO_HOR,
d.DS_OBSERVACAO,
SUBSTR(obter_valor_dominio(1227,d.IE_AUTORIZACAO),1,255) AUTORIZACAO,
obter_dados_pf(b.cd_medico, 'NA') MEDICO,
d.NR_SEQ_PROC_INTERNO
from PRESCR_PROCEDIMENTO D, PRESCR_MEDICA B, ATENDIMENTO_PACIENTE_V A, EXAME_LABORATORIO EX, PROC_INTERNO PR
where b.nr_prescricao = d.nr_prescricao
and a.nr_atendimento = b.nr_atendimento
and d.NR_SEQ_PROC_INTERNO = PR.NR_SEQUENCIA
and d.nr_seq_exame = ex.NR_SEQ_EXAME(+)
and (B.nr_atendimento = :NR_ATENDIMENTO or :NR_ATENDIMENTO = 0)
and (trunc(a.dt_entrada) = :DATA or :DATA = 0)
--and (PR.NR_SEQ_CLASSIF = :CLASSIFICACAO or :CLASSIFICACAO = 0)
order by 1