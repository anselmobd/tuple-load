------------------
------------------
		referencia com roteiros de PA: Z01PA
------------------
------------------

--- atribuindo fluxos 1, 2 e 3 de PA para costurado individual (não kit) (não sunga)
--- script PA-a.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (1, 2, 3, 4)

- alt/roteiros a atribuir
(1, 11, 21, 2, 12, 22, 3, 13, 23)

--- atribuindo fluxos 1, 2 e 3 de PA para costurado kit (não sunga)
--- script PA-b.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (13, 14, 15)

- alt/roteiros a atribuir
(1, 21, 2, 22, 3, 23)

--- atribuindo fluxo 4 de PA para sem costura individual (não kit)
--- script PA-c.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (9, 10, 11, 12)

- alt/roteiros a atribuir
(4, 14, 24)

--- atribuindo fluxo 4 de PA para sem costura kit
--- script PA-d.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (16, 17)

- alt/roteiros a atribuir
(4, 24)

--- atribuindo fluxos 1 e 5 de PA para sunga individual
--- script PA-e.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (8)

- alt/roteiros a atribuir
(1, 11, 21, 5, 15, 25)

--- atribuindo fluxo 7 de PA para pijama
--- script PA-f.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA < 'A0000'
  AND r.COLECAO IN (7)

- alt/roteiros a atribuir
(7, 27)

------------------
------------------
		referencia com roteiros de PG: Z01PG
------------------
------------------

--- atribuindo fluxos 1, 2 e 3 de PG para costurado (não sunga)
--- script PG-a.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'A%'
  AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)

- alt/roteiros a atribuir
(21, 22, 23)

--- atribuindo fluxo 4 de PG para sem costura
--- script PG-b.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'A%'
  AND r.COLECAO IN (9, 10, 11, 12, 16, 17)

- alt/roteiros a atribuir
(24)

--- atribuindo fluxos 1 e 5 de PG para sunga individual
--- script PG-c.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'A%'
  AND r.COLECAO IN (8)

- alt/roteiros a atribuir
(25)

--- atribuindo fluxo 7 de PG para pijama
--- script PG-d.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'A%'
  AND r.COLECAO IN (7)

- alt/roteiros a atribuir
(27)

------------------
------------------
		referencia com roteiros de PB: Z01PB
------------------
------------------

--- atribuindo fluxos 1, 2 e 3 de PB para costurado (não sunga)
--- script PB-a.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'B%'
  AND r.COLECAO IN (1, 2, 3, 4)

- alt/roteiros a atribuir
(11, 12, 13)

--- atribuindo fluxo 4 de PB para sem costura
--- script PB-b.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'B%'
  AND r.COLECAO IN (9, 10, 11, 12)

- alt/roteiros a atribuir
(14)

--- atribuindo fluxos 1 e 5 de PB para sunga individual
--- script PB-c.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'B%'
  AND r.COLECAO IN (8)

- alt/roteiros a atribuir
(15)

------------------
------------------
		referencia com roteiros de MD: Z01MD
------------------
------------------

---------
--------- MD com costura
---------

--- atribuindo fluxos 1 de MD com costura (não sunga, não camisa)
--- script MD-a.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'M%'
  AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)

- alt/roteiros a atribuir
(1)

--- atribuindo fluxos 1 e 5 de MD sunga
--- script MD-b.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'M%'
  AND r.COLECAO IN (8)

- alt/roteiros a atribuir
(1, 5)

--- atribuindo fluxos 6 de MD camisa
--- script MD-c.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'M%'
  AND r.COLECAO IN (5)

- alt/roteiros a atribuir
(6)

---------
--------- MD sem costura
---------

--- atribuindo fluxos 4 de MD sem costura
--- script MD-d.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND (
     r.REFERENCIA like 'E%'
  OR r.REFERENCIA like 'Q%'
  OR r.REFERENCIA like 'L%'
  OR r.REFERENCIA like 'N%'
  OR r.REFERENCIA like 'P%'
  OR r.REFERENCIA like 'M%'
  )
  AND r.COLECAO IN (9, 10, 11, 12, 16, 17)

- alt/roteiros a atribuir
(4)

---------
--------- MD só riscado
---------

--- atribuindo fluxos 3 de MD só riscado
--- script MD-e.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND (
     r.REFERENCIA like 'T%'
  OR r.REFERENCIA like 'R%'
  )
  AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)

- alt/roteiros a atribuir
(3)

---------
--------- MD só cortado
---------

--- atribuindo fluxos 2 de MD só cortado
--- script MD-f.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND (
     r.REFERENCIA like 'E%'
  OR r.REFERENCIA like 'C%'
  )
  AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)

- alt/roteiros a atribuir
(2)

------------------
------------------
		referencia com roteiros de MP: Z01MP
------------------
------------------

---------
--------- FORRO
---------

--- atribuindo fluxo 8 de MP forro de sunga
--- script MP-a.sql

- seleção de referências
SELECT
  r.REFERENCIA
FROM basi_030 r -- referência
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.RESPONSAVEL IS NOT NULL
  AND r.REFERENCIA like 'F%'
  AND r.COLECAO IN (8)

- alt/roteiros a atribuir
(8)
