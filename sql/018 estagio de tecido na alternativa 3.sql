UPDATE BASI_050
SET ESTAGIO=24
WHERE (nivel_comp = 1 or nivel_comp = 2) and alternativa_item = 3
  AND ESTAGIO <> 24
;
