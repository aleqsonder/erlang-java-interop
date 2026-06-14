#!/usr/bin/env bash
set -euo pipefail

JI_JAR=${JINTERFACE_JAR:-$(find /usr/lib/erlang/lib -name 'OtpErlang.jar' 2>/dev/null | head -1)}
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[Example 2] Компиляция Erlang FactorialServer..."
erlc -o "${DIR}" "${DIR}/FactorialServer.erl"

echo "[Example 2] Компиляция Java FactorialClient..."
javac -cp ".:${JI_JAR}" -d "${DIR}" "${DIR}/FactorialClient.java"

echo "[Example 2] Запуск Erlang FactorialServer в фоне..."
erl -noshell -pa "${DIR}" -eval "'FactorialServer':start()" &
ERL_PID=$!
sleep 1

echo "[Example 2] Запуск Java FactorialClient..."
java -cp "${DIR}:${JI_JAR}" FactorialClient

wait $ERL_PID 2>/dev/null || true
echo "[Example 2] Готово."
