#!/usr/bin/env bash
set -euo pipefail

JI_JAR=${JINTERFACE_JAR:-$(find /usr/lib/erlang/lib -name 'OtpErlang.jar' 2>/dev/null | head -1)}
export JINTERFACE_JAR="$JI_JAR"
export JI_JAR

echo "Using JInterface JAR: $JI_JAR"
echo ""

# Запускаем epmd если не запущен
epmd -daemon 2>/dev/null || true
sleep 0.5

echo "============================================"
echo " ПРИМЕР 1: JInterface — Erlang вызывает Java (Fibonacci)"
echo "============================================"
bash jinterface/run.sh
echo ""

echo "============================================"
echo " ПРИМЕР 2: JInterface — Java вызывает Erlang (Factorial)"
echo "============================================"
bash erlang_in_java/run.sh
echo ""

echo "============================================"
echo " ПРИМЕР 3: Port FFI — Java как внешний Erlang Port"
echo "============================================"
bash port_ffi/run.sh
echo ""

echo "=== Все примеры выполнены ==="
