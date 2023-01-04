--- Consultar Geração de LOTE através da PRECRIÇÂO e MATERIAL

select  decode(d.ie_gerar_lote, null, 'S', d.ie_gerar_lote)  "MAT - CB Gerar_Lote_Prescricao",
       decode(d.ie_gera_lote_separado, null, 'N', d.ie_gera_lote_separado) "MAT - CB Gerar_Lote_Separado",
       decode(e.ie_gerar_ap_lote, null, 'Não caiu em regra ou está null', e.ie_gerar_ap_lote) "REGRA DISP - CB Gerar_Lote",
       g.ie_gera_lote "ESTOQUE - Gerar Lote Prescr",
       f.ie_gerar_lote "SETOR - CB Gerar_Lote",
       f.ie_gerar_lote_unico "SETOR - CB Gerar_Lote_Unico",
       b.cd_material,
       obter_desc_material(b.cd_material) "DS_MATERIAL",
       b.cd_intervalo,
       b.ds_horarios,
       b.ds_horarios_medico,
       b.cd_motivo_baixa,
       b.dt_baixa,
       decode(b.nr_seq_regra_local, null, 'Não caiu em regra', b.nr_seq_regra_local) "REGRA DISP - PRESCR_MATERIAL",
       b.cd_local_estoque "CD ESTOQUE - PRESCR_MATERIAL",
       obter_desc_local_estoque(b.cd_local_estoque) "DS ESTOQUE - PRESCR_MATERIAL",
       decode(a.nr_seq_regra_disp, null, 'Não caiu em regra', a.nr_seq_regra_disp) "REGRA DISP - MAT_HOR (851=S)",
       a.cd_local_estoque "CD ESTOQUE - PRESCR_MAT_HOR",
       obter_desc_local_estoque(a.cd_local_estoque) "DS ESTOQUE - MAT_HOR",
       to_char(a.dt_horario, 'dd/mm/yyyy hh24:mi:ss'), a.qt_dispensar, a.qt_dispensar_hor, a.nr_ocorrencia, a.cd_unidade_medida_dose, a.cd_unidade_medida, a.nr_seq_turno, a.nr_seq_classif, to_char(dt_lib_horario, 'dd/mm/yyyy hh24:mi:ss') "DT_LIB_HORARIO"
from prescr_mat_hor a,  prescr_material b, prescr_medica c, material d, regra_local_dispensacao e, setor_atendimento f, local_estoque g
       where a.cd_material = b.cd_material
       and a.nr_prescricao = b.nr_prescricao
       and b.nr_prescricao = c.nr_prescricao
       and d.cd_material = b.cd_material
       and b.nr_seq_regra_local = e.nr_sequencia(+)
       and c.cd_setor_atendimento = f.cd_setor_atendimento
       and b.cd_local_estoque = g.cd_local_estoque
and c.nr_prescricao =  :NR_PRESCRICAO
and b.cd_material = :CD_MATERIAL


--- Consultar dispensação do Lote

select
b.NR_ATENDIMENTO NR_ATENDIMENTO,
-- Lote
b.NR_PRESCRICAO PRESCRICAO,
a.nr_seq_lote as NUM_LOTE,
obter_desc_turno_disp(b.NR_SEQ_TURNO) TURNO,
to_char(b.DT_DISP_FARMACIA,'dd/mm/yyyy hh24:mi:ss') DISP_FARMACIA,
b.DT_RECEBIMENTO_SETOR RECEBIMENTO,
obter_valor_dominio(2116, b.IE_STATUS_LOTE) STATUS_LOTE,
obter_desc_setor_atend(b.CD_SETOR_ATENDIMENTO) SETOR,
to_char(b.DT_ATEND_LOTE,'dd/mm/yyyy hh24:mi:ss') ATEND_LOTE,
to_char(b.DT_PRIM_HORARIO,'dd/mm/yyyy hh24:mi:ss')  PRIM_HORARIO,
obter_desc_local_estoque(b.CD_LOCAL_ESTOQUE) LOCAL_ESTOQUE,
-- Item
a.CD_MATERIAL CD_MATERIAL,
obter_desc_material(a.CD_MATERIAL) MAT_MED,
a.QT_DISPENSAR QT_DISPENSAR
from ap_lote b, ap_lote_item a
where b.nr_sequencia = a.nr_seq_lote
and a.cd_material = :CD_MATERIAL
and  nr_prescricao = :NR_PRESCRICAO