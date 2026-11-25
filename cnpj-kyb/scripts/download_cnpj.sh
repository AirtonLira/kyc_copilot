#!/usr/bin/env bash
set -euo pipefail

BASE="https://huggingface.co/datasets/andrelacerda23/cnpj-dados-receita-brasil-2026-10/resolve/main"
DEST="data/raw"

arquivos=(
  cnaes/cnaes.parquet
  municipios/municipios.parquet
  naturezas_juridicas/naturezas.parquet
  paises/paises.parquet
  qualificacoes_socios/qualificacoes.parquet
  motivos_situacoes/motivos.parquet
  simples/simples.parquet
)
for i in 0 1 2 3 4 5 6 7 8 9; do
  arquivos+=("empresas/empresas$i.parquet" "estabelecimentos/estabelecimentos$i.parquet" "socios/socios$i.parquet")
done

for f in "${arquivos[@]}"; do
  if [ -f "$DEST/$f" ]; then continue; fi          # já baixado
  mkdir -p "$DEST/$(dirname "$f")"
  curl -L --fail --retry 3 -C - -o "$DEST/$f.part" "$BASE/$f"
  mv "$DEST/$f.part" "$DEST/$f"                    # só vira .parquet quando termina
done