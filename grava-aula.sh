#!/usr/bin/env bash
# Grava o áudio de uma aula direto no formato que o whisper.cpp espera (WAV 16 kHz, mono).
# Organiza por matéria: $AULAS_DIR/<matéria>/audios/AAAA-MM-DD_HHMM.wav
#
# Uso:
#   grava-aula.sh               -> mostra um menu com as matérias de materias.txt
#   grava-aula.sh "Estatística" -> grava direto nessa matéria
set -euo pipefail

AULAS_DIR="${AULAS_DIR:-$HOME/Aulas}"
PASTA_SCRIPT="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
LISTA_MATERIAS="${LISTA_MATERIAS:-$PASTA_SCRIPT/materias.txt}"

if ! command -v arecord >/dev/null 2>&1; then
  echo "Erro: 'arecord' não encontrado. Instale o pacote alsa-utils." >&2
  exit 1
fi

if [ -n "${1:-}" ]; then
  MATERIA="$1"
else
  if [ ! -f "$LISTA_MATERIAS" ]; then
    echo "Crie o arquivo $LISTA_MATERIAS com uma matéria por linha" >&2
    echo "(veja materias.exemplo.txt) ou passe o nome da matéria como argumento." >&2
    exit 1
  fi
  mapfile -t MATERIAS < <(grep -v '^[[:space:]]*\(#\|$\)' "$LISTA_MATERIAS")
  echo "Escolha a matéria:"
  PS3="Número: "
  select MATERIA in "${MATERIAS[@]}"; do
    [ -n "$MATERIA" ] && break
    echo "Opção inválida, tente de novo."
  done
fi

PASTA="$AULAS_DIR/$MATERIA/audios"
mkdir -p "$PASTA" "$AULAS_DIR/$MATERIA/transcricoes" "$AULAS_DIR/$MATERIA/resumos"
ARQUIVO="$PASTA/$(date +%Y-%m-%d_%H%M).wav"

echo "Gravando a aula de '$MATERIA'..."
echo "Pressione Ctrl+C para parar e salvar."
# Ctrl+C encerra o arecord; o arquivo continua válido.
arecord -f S16_LE -r 16000 -c 1 "$ARQUIVO" || true

echo ""
echo "Gravação salva em: $ARQUIVO"
echo "Para transcrever: transcreve-aula.sh \"$ARQUIVO\""
