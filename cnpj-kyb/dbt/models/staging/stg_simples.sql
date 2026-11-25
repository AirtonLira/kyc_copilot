-- Só o recorte, sem limpeza: ainda não confirmei os nomes das colunas desta tabela.
-- Quando você me mandar o DESCRIBE dela, a gente limpa.
select *
from {{ source('raw', 'simples') }}
where cnpj_basico in (select cnpj_basico from {{ ref('slice_cnpj') }})