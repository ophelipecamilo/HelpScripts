---- INSERT ADM DO SISTEMA - PERFIL ADM PADRÃO CÓDIGO 1848
-- EDITAR O NOME DO USUÁRIO NO LOCAL ESPECIFICADO!

INSERT INTO USUARIO_PERFIL
(CD_PERFIL,DS_OBSERVACAO,DS_UTC,DS_UTC_ATUALIZACAO,DT_ATUALIZACAO,DT_LIBERACAO,DT_VALIDADE,IE_HORARIO_VERAO,NM_USUARIO,NM_USUARIO_ATUAL,NR_SEQ_APRES,NR_SEQUENCIA)
VALUES (1848,null,'07/04/2022T08:39:55-03:00','07/04/2022T08:39:55-03:00',sysdate,sysdate,null,'N','NOME_USUARIO','NOME_USUARIO',1,USUARIO_PERFIL_SEQ.nextval)
;
commit;
