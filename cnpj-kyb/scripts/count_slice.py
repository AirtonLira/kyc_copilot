import duckdb

con = duckdb.connect("/app/data/kyb.duckdb", read_only=True)
total = 0
for t in ["stg_empresas", "stg_estabelecimentos", "stg_socios", "stg_simples", "dim_empresa", "fato_socio"]:
    n = con.execute(f"SELECT count(*) FROM main.{t}").fetchone()[0]
    if t.startswith("stg_"):
        total += n
    print(f"{t:<24}{n:>14,}")
print(f"{'RECORTE (4 stg_)':<24}{total:>14,}")