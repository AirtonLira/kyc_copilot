-- Recorte do projeto: empresas cuja MATRIZ está nas UFs de var('ufs').
select distinct cnpj_basico
from {{ source('raw', 'estabelecimentos') }}
where identificador_matriz_filial = '1'
  and uf in ({{ "'" ~ var('ufs') | join("','") ~ "'" }})