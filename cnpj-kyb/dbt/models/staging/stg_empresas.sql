-- Há empresas com mais de uma linha no cru (ex.: 08314885), sendo uma delas vazia (placeholder).
-- Fica a linha com razão social preenchida; em caso de empate, a de maior natureza jurídica.
select
    cnpj_basico,
    nullif(trim(razao_social), '')                                as razao_social,
    natureza_juridica,
    qualificacao_responsavel,
    try_cast(replace(capital_social, ',', '.') as decimal(20, 2)) as capital_social,
    case porte_empresa
        when '01' then 'micro'
        when '03' then 'pequeno'
        when '05' then 'demais'
        else 'nao_informado'
    end                                                           as porte,
    nullif(trim(ente_federativo), '')                             as ente_federativo
from {{ source('raw', 'empresas') }}
where cnpj_basico in (select cnpj_basico from {{ ref('slice_cnpj') }})
qualify row_number() over (
    partition by cnpj_basico
    order by (nullif(trim(razao_social), '') is not null) desc, natureza_juridica desc
) = 1