#!/usr/bin/env bash
set -euo pipefail

JI_JAR=${JINTERFACE_JAR:-$(find /usr/lib/erlang/lib -name 'OtpErlang.jar' 2>/dev/null | head -1)}
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[Example 1] Компиляция Java FibServer..."
javac -cp ".:${JI_JAR}" -d "${DIR}/java_node" "${DIR}/java_node/FibServer.java"

echo "[Example 1] Компиляция Erlang fib_client..."
erlc -o "${DIR}/erlang_client" "${DIR}/erlang_client/fib_client.erl"

echo "[Example 1] Запуск Java FibServer в фоне..."
java -cp "${DIR}/java_node:${JI_JAR}" FibServer &
JAVA_PID=$!
sleep 1

echo "[Example 1] Запуск Erlang-клиента..."
erl -noshell -pa "${DIR}/erlang_client" -eval 'fib_client:main()'

wait $JAVA_PID 2>/dev/null || true
echo "[Example 1] Готово."
