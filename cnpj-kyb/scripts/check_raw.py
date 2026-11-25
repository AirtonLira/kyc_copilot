import sys
import duckdb

con = duckdb.connect("/app/data/kyb.duckdb", read_only=True)

tabelas = [r[0] for r in con.execute(
    "SELECT table_name FROM information_schema.tables WHERE table_schema = 'raw' ORDER BY 1"
).fetchall()]
if len(tabelas) != 10:
    sys.exit(f"esperava 10 views em raw, achei {len(tabelas)}: rode scripts/load_raw.py")

falhas = 0
for t in tabelas:
    cols = con.execute(
        "SELECT column_name, data_type FROM information_schema.columns "
        "WHERE table_schema = 'raw' AND table_name = ?", [t]
    ).fetchall()
    fora = [(c, tp) for c, tp in cols if tp != "VARCHAR"]
    print(f"{t:<22}{len(cols):>3} colunas  {'OK' if not fora else 'FALHA ' + str(fora)}")
    falhas += bool(fora)

print("\nAmostra de raw.estabelecimentos:")
con.sql("SELECT cnpj_basico, uf, situacao_cadastral, data_inicio_atividade FROM raw.estabelecimentos LIMIT 5").show()

sys.exit(1 if falhas else 0)