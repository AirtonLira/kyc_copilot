import duckdb

RAW = "/app/data/raw"  # caminho absoluto do container; o dbt vai precisar dele igual
TABELAS = [
    "empresas", "estabelecimentos", "socios", "simples",
    "cnaes", "municipios", "naturezas_juridicas",
    "qualificacoes_socios", "motivos_situacoes", "paises",
]

con = duckdb.connect("/app/data/kyb.duckdb")
con.execute("CREATE SCHEMA IF NOT EXISTS raw")
total = 0
for t in TABELAS:
    con.execute(f"CREATE OR REPLACE VIEW raw.{t} AS SELECT * FROM read_parquet('{RAW}/{t}/*.parquet')")
    n = con.execute(f"SELECT count(*) FROM raw.{t}").fetchone()[0]
    total += n
    print(f"{t:<22}{n:>14,}")
print(f"{'TOTAL':<22}{total:>14,}")