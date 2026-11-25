import duckdb

con = duckdb.connect("/app/data/kyb.duckdb", read_only=True)
total = sum(
    con.execute(f"SELECT count(*) FROM raw.{t}").fetchall()[0][0]
    for t in ("empresas", "estabelecimentos", "socios", "simples")
)
con.sql(f"""
    SELECT uf,
           count(*)                                                      AS empresas,
           round(100 * count(*) / sum(count(*)) OVER (), 1)              AS pct,
           round({total} * count(*) / sum(count(*)) OVER () / 1e6, 1)    AS linhas_mi,
           round({total} * sum(count(*)) OVER (ORDER BY count(*) DESC)
                 / sum(count(*)) OVER () / 1e6, 1)                       AS linhas_acum_mi
    FROM raw.estabelecimentos
    WHERE identificador_matriz_filial = '1'
    GROUP BY uf
    ORDER BY empresas DESC
""").show(max_rows=40)