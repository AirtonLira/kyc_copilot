select
    cnpj_basico,
    case identificador_socio
        when '1' then 'pessoa_juridica'
        when '2' then 'pessoa_fisica'
        when '3' then 'estrangeiro'
    end                                                           as tipo_socio,
    nullif(trim(nome_socio), '')                                  as nome_socio,
    nullif(trim(cpf_cnpj_socio), '')                              as cpf_cnpj_socio,  -- CPF já vem mascarado
    qualificacao_socio,
    try_strptime(data_entrada_sociedade, '%Y%m%d')::date          as data_entrada_sociedade,
    pais,
    nullif(trim(nome_representante), '')                          as nome_representante
from {{ source('raw', 'socios') }}
where cnpj_basico in (select cnpj_basico from {{ ref('slice_cnpj') }})