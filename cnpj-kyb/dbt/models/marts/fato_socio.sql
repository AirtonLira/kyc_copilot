select
    s.cnpj_basico,
    md5(coalesce(upper(s.nome_socio), '') || '|' || coalesce(s.cpf_cnpj_socio, '')) as socio_chave,
    s.tipo_socio,
    s.nome_socio,
    s.cpf_cnpj_socio,
    s.qualificacao_socio,
    q.descricao                                                                     as qualificacao,
    s.data_entrada_sociedade
from {{ ref('stg_socios') }} s
left join {{ source('raw', 'qualificacoes_socios') }} q on q.codigo = s.qualificacao_socio