#!/usr/bin/env bash
# Baixa e compila o whisper.cpp e baixa o modelo "medium" (~1,5 GB).
#
# Uso:
#   ./instalar.sh            -> compila para CPU
#   ./instalar.sh --vulkan   -> compila com aceleração por GPU via Vulkan
#                               (precisa de vulkan-headers e do driver Vulkan da sua placa)
set -euo pipefail

WHISPER_DIR="${WHISPER_DIR:-$HOME/ferramentas/whisper.cpp}"
MODELO_NOME="${MODELO_NOME:-medium}"

for cmd in git cmake make; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Erro: instale '$cmd' primeiro." >&2; exit 1; }
done

if [ ! -d "$WHISPER_DIR" ]; then
  git clone https://github.com/ggml-org/whisper.cpp "$WHISPER_DIR"
fi

CMAKE_ARGS=(-B "$WHISPER_DIR/build" -S "$WHISPER_DIR" -DCMAKE_BUILD_TYPE=Release)
if [ "${1:-}" = "--vulkan" ]; then
  CMAKE_ARGS+=(-DGGML_VULKAN=ON)
  echo "Compilando com Vulkan (GPU)..."
else
  echo "Compilando para CPU..."
fi
cmake "${CMAKE_ARGS[@]}"
cmake --build "$WHISPER_DIR/build" -j "$(nproc)" --config Release

bash "$WHISPER_DIR/models/download-ggml-model.sh" "$MODELO_NOME"

echo ""
echo "Pronto! whisper-cli em: $WHISPER_DIR/build/bin/whisper-cli"
echo "Modelo em: $WHISPER_DIR/models/ggml-$MODELO_NOME.bin"
