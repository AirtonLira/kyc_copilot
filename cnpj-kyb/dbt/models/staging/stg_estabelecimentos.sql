select
    cnpj_basico,
    cnpj_basico || cnpj_ordem || cnpj_dv                          as cnpj,
    identificador_matriz_filial = '1'                             as eh_matriz,
    nullif(trim(nome_fantasia), '')                               as nome_fantasia,
    case situacao_cadastral
        when '01' then 'nula'
        when '02' then 'ativa'
        when '03' then 'suspensa'
        when '04' then 'inapta'
        when '08' then 'baixada'
    end                                                           as situacao_cadastral,
    try_strptime(data_situacao_cadastral, '%Y%m%d')::date         as data_situacao_cadastral,
    motivo_situacao_cadastral,
    try_strptime(data_inicio_atividade, '%Y%m%d')::date           as data_inicio_atividade,
    cnae_fiscal_principal,
    nullif(trim(tipo_logradouro), '')                             as tipo_logradouro,
    nullif(trim(logradouro), '')                                  as logradouro,
    nullif(trim(numero), '')                                      as numero,
    nullif(trim(complemento), '')                                 as complemento,
    nullif(trim(bairro), '')                                      as bairro,
    nullif(trim(cep), '')                                         as cep,
    nullif(trim(uf), '')                                          as uf,
    municipio                                                     as municipio_cod,
    nullif(trim(correio_eletronico), '')                          as email
from {{ source('raw', 'estabelecimentos') }}
where cnpj_basico in (select cnpj_basico from {{ ref('slice_cnpj') }})