#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "${DIR}/.." && pwd)"

echo "[Example 3] Компиляция Java PortServer..."
javac -d "${DIR}/java_port" "${DIR}/java_port/PortServer.java"

echo "[Example 3] Компиляция Erlang port_driver..."
erlc -o "${DIR}" "${DIR}/port_driver.erl"

echo "[Example 3] Запуск через Erlang..."
cd "${ROOT}"
erl -noshell -pa "${DIR}" -eval "port_driver:main(), init:stop()."
echo "[Example 3] Готово."
