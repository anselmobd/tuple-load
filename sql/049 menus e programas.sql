-- compara menus de duas pessoas

SELECT
  u.*
FROM HDOC_033 u
WHERE u.USU_PRG_CDUSU = 'GISELLE_PRO'
   OR u.USU_PRG_CDUSU = 'VANESSA_PRO'
ORDER BY
  u.PROGRAMA
, u.USU_PRG_CDUSU
;

-- apaga menus de uma pessoa

DELETE FROM HDOC_033 u
WHERE u.USU_PRG_CDUSU = 'VANESSA_PRO'
;

-- copia menus de uma pessoa

INSERT INTO SYSTEXTIL.HDOC_033
(USU_PRG_CDUSU, USU_PRG_EMPR_USU, PROGRAMA, NOME_MENU, ITEM_MENU, ORDEM_MENU, INCLUIR, MODIFICAR, EXCLUIR, PROCURAR, COORDENADA_X, COORDENADA_Y, MARGEM_ESQ_RELATORIOS)
--VALUES('INTERSYS', 1, 'cobr_f305', 'cobr_menu', 1, 1, 'S', 'S', 'S', 'S', 0, 0, 0);
SELECT 'VANESSA_PRO', USU_PRG_EMPR_USU, PROGRAMA, NOME_MENU, ITEM_MENU, ORDEM_MENU, INCLUIR, MODIFICAR, EXCLUIR, PROCURAR, COORDENADA_X, COORDENADA_Y, MARGEM_ESQ_RELATORIOS
FROM SYSTEXTIL.HDOC_033
WHERE USU_PRG_CDUSU='GISELLE_PRO' AND USU_PRG_EMPR_USU=1
;

-- buscando todos os níveis filhos de um menu principal

SELECT DISTINCT
  SUBSTR(u.PROGRAMA, 1, 4) prg
, u.PROGRAMA
, p.DESCRICAO
, p.LOCALE
, u.ORDEM_MENU
, u.NOME_MENU
, m.DESCRICAO
, up1.PROGRAMA  prg1
, up1.NOME_MENU mnu1
, up2.PROGRAMA  prg2
, up2.NOME_MENU mnu2
, up3.PROGRAMA  prg3
, up3.NOME_MENU mnu3
, up4.PROGRAMA  prg4
, up4.NOME_MENU mnu4
, up5.PROGRAMA  prg5
, up5.NOME_MENU mnu5
, u.*
FROM HDOC_033 u
LEFT JOIN HDOC_033 up1
  ON up1.USU_PRG_CDUSU = u.USU_PRG_CDUSU
 AND up1.PROGRAMA = u.NOME_MENU
LEFT JOIN HDOC_033 up2
  ON up2.USU_PRG_CDUSU = up1.USU_PRG_CDUSU
 AND up2.PROGRAMA = up1.NOME_MENU
LEFT JOIN HDOC_033 up3
  ON up3.USU_PRG_CDUSU = up2.USU_PRG_CDUSU
 AND up3.PROGRAMA = up2.NOME_MENU
LEFT JOIN HDOC_033 up4
  ON up4.USU_PRG_CDUSU = up3.USU_PRG_CDUSU
 AND up4.PROGRAMA = up3.NOME_MENU
LEFT JOIN HDOC_033 up5
  ON up5.USU_PRG_CDUSU = up4.USU_PRG_CDUSU
 AND up5.PROGRAMA = up4.NOME_MENU
LEFT JOIN HDOC_035 m
  ON m.CODIGO_PROGRAMA = u.NOME_MENU
LEFT JOIN HDOC_036 p
  ON p.CODIGO_PROGRAMA = u.PROGRAMA
 AND p.LOCALE = 'pt_BR'
WHERE u.USU_PRG_CDUSU = 'M__PRODUTO'
  --AND u.PROGRAMA = 'oper_f220'
  AND (  1=2
      --OR up4.NOME_MENU IS NOT NULL
      OR   u.NOME_MENU = 'menu_mp02'
      OR up1.NOME_MENU = 'menu_mp02'
      OR up2.NOME_MENU = 'menu_mp02'
      OR up3.NOME_MENU = 'menu_mp02'
      OR up4.NOME_MENU = 'menu_mp02'
      OR up5.NOME_MENU = 'menu_mp02'
      OR u.PROGRAMA LIKE 'ftec%'
      OR u.PROGRAMA LIKE 'basi%'
      OR u.PROGRAMA LIKE 'meia%'
      OR u.PROGRAMA LIKE 'efic%'
      OR u.PROGRAMA LIKE 'mqop%'
      )
ORDER BY
  u.NOME_MENU
, u.ORDEM_MENU
, p.DESCRICAO
, u.PROGRAMA
;
