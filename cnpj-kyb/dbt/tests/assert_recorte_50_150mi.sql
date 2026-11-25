with total as (
    select (select count(*) from {{ ref('stg_empresas') }})
         + (select count(*) from {{ ref('stg_estabelecimentos') }})
         + (select count(*) from {{ ref('stg_socios') }})
         + (select count(*) from {{ ref('stg_simples') }}) as linhas
)
select linhas from total where linhas not between {{ var('recorte_min') }} and {{ var('recorte_max') }}