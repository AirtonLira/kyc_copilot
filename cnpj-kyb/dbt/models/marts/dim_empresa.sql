with matriz as (
    select *
    from {{ ref('stg_estabelecimentos') }}
    where eh_matriz
    -- há CNPJs com mais de uma linha marcada como matriz: fica a de menor CNPJ
    qualify row_number() over (partition by cnpj_basico order by cnpj) = 1
)

select
    e.cnpj_basico,
    e.razao_social,
    e.capital_social,
    e.porte,
    nj.descricao                 as natureza_juridica,
    m.cnpj                       as cnpj_matriz,
    m.situacao_cadastral,
    m.data_situacao_cadastral,
    m.data_inicio_atividade,
    m.uf,
    mu.descricao                 as municipio,
    m.cnae_fiscal_principal,
    cn.descricao                 as cnae_principal,
    m.logradouro,
    m.numero,
    m.bairro,
    m.cep
from {{ ref('stg_empresas') }} e
left join matriz m on m.cnpj_basico = e.cnpj_basico
left join {{ source('raw', 'naturezas_juridicas') }} nj on nj.codigo = e.natureza_juridica
left join {{ source('raw', 'municipios') }}          mu on mu.codigo = m.municipio_cod
left join {{ source('raw', 'cnaes') }}               cn on cn.codigo = m.cnae_fiscal_principal