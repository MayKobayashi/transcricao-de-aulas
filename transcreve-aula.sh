#!/usr/bin/env bash
# Transcreve o áudio de uma aula (.wav) para texto com o whisper.cpp, 100% local, em português.
# Descobre a matéria pelo caminho do arquivo ($AULAS_DIR/<matéria>/audios/arquivo.wav)
# e salva em $AULAS_DIR/<matéria>/transcricoes/arquivo.txt
#
# Se existir $AULAS_DIR/<matéria>/vocabulario.txt, ele é usado como "prompt inicial":
# ajuda o modelo a acertar termos técnicos da disciplina (ex.: "join" em vez de "joinha").
set -euo pipefail

WHISPER_DIR="${WHISPER_DIR:-$HOME/ferramentas/whisper.cpp}"
WHISPER="${WHISPER:-$WHISPER_DIR/build/bin/whisper-cli}"
MODELO="${MODELO:-$WHISPER_DIR/models/ggml-medium.bin}"

if [ -z "${1:-}" ]; then
  echo "Uso: transcreve-aula.sh <arquivo.wav>" >&2
  exit 1
fi
for f in "$WHISPER" "$MODELO" "$1"; do
  if [ ! -e "$f" ]; then
    echo "Erro: não encontrei '$f'. Rodou o instalar.sh?" >&2
    exit 1
  fi
done

ARQUIVO="$(realpath "$1")"
NOME="$(basename "$ARQUIVO" .wav)"
PASTA_MATERIA="$(dirname "$(dirname "$ARQUIVO")")"
MATERIA="$(basename "$PASTA_MATERIA")"
PASTA_SAIDA="$PASTA_MATERIA/transcricoes"
mkdir -p "$PASTA_SAIDA"
SAIDA="$PASTA_SAIDA/$NOME"

PROMPT_ARGS=()
VOCAB="$PASTA_MATERIA/vocabulario.txt"
if [ -f "$VOCAB" ]; then
  PROMPT_ARGS=(--prompt "$(cat "$VOCAB")" --carry-initial-prompt)
fi

echo "Transcrevendo a aula de '$MATERIA' (pode levar alguns minutos)..."
"$WHISPER" -m "$MODELO" -l pt -t "$(nproc)" "${PROMPT_ARGS[@]}" -f "$ARQUIVO" -otxt -of "$SAIDA"

echo ""
echo "Transcrição salva em: $SAIDA.txt"
echo "Para resumir, use o prompt de prompts/resumo_de_aula.md com a sua IA preferida."
