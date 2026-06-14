#!/usr/bin/env bash
set -euo pipefail

echo "=== Установка зависимостей для Debian Stable ==="

apt-get update -qq
apt-get install -y \
  erlang \
  erlang-jinterface \
  openjdk-17-jdk \
  maven \
  epmd

echo ""
echo "=== Версии установленного ПО ==="
erl -eval 'io:format("Erlang/OTP: ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell
java -version
mvn -version

JI_JAR=$(find /usr/lib/erlang/lib -name 'OtpErlang.jar' 2>/dev/null | head -1 || true)
if [ -z "$JI_JAR" ]; then
  echo "WARN: OtpErlang.jar не найден через /usr/lib/erlang. Ищем в /usr/share..."
  JI_JAR=$(find /usr/share -name 'OtpErlang.jar' 2>/dev/null | head -1 || true)
fi

if [ -n "$JI_JAR" ]; then
  echo "JInterface JAR: $JI_JAR"
  echo "export JINTERFACE_JAR=$JI_JAR" > /etc/profile.d/erlang_jinterface.sh
  export JINTERFACE_JAR="$JI_JAR"
else
  echo "ERROR: OtpErlang.jar не найден. Проверьте пакет erlang-jinterface."
  exit 1
fi

echo ""
echo "=== Зависимости установлены успешно ==="
