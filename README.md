# Erlang ↔ Java Interoperability Demo

Демонстрация взаимодействия между программами на **Erlang** и **Java**.

Целевая ОС: **Debian Stable**

## Структура проекта

```
.
├── jinterface/           # Взаимодействие через JInterface (OtpErlang.jar)
│   ├── java_node/        # Java-узел: сервер вычисления Fibonacci
│   │   └── FibServer.java
│   └── erlang_client/    # Erlang: вызов Java-сервера Fibonacci
│       └── fib_client.erl
├── erlang_in_java/       # Вызов Erlang-функции (факториал) из Java через JInterface
│   ├── FactorialServer.erl
│   └── FactorialClient.java
├── port_ffi/             # Альтернатива FFI: взаимодействие через Erlang Port
│   ├── java_port/
│   │   └── PortServer.java
│   └── port_driver.erl
├── setup.sh              # Скрипт установки зависимостей
└── run_all.sh            # Запуск всех примеров
```

## Быстрый старт

```bash
# 1. Установка зависимостей (Debian)
sudo bash setup.sh

# 2. Запуск всех примеров
bash run_all.sh
```

## Требования

- Debian Stable
- Erlang/OTP ≥ 25 (`erlang`, `erlang-jinterface`)
- Java 17+ (`openjdk-17-jdk`)
- Maven 3+ (`maven`)
- `epmd` (устанавливается с erlang)

## Примеры

### 1. JInterface: Erlang → Java (Fibonacci)

Java-узел регистрируется как Erlang-нода и отвечает на запросы вычисления числа Фибоначчи.
Erlang отправляет `{self(), N}`, Java отвечает `{ok, Result}`.

См. [`jinterface/`](./jinterface)

### 2. JInterface: Java → Erlang (Factorial)

Erlang-нода запускает модуль `factorial_server`, Java подключается через JInterface,
отправляет запрос и получает ответ.

См. [`erlang_in_java/`](./erlang_in_java)

### 3. Port FFI: Java через Erlang Port (альтернатива FFI)

Erlang запускает Java-процесс как внешний Port. Общение через stdin/stdout.
Dемонстрирует Port-механизм как "Erlang FFI" для JVM-процессов.

См. [`port_ffi/`](./port_ffi)

## Примечания по FFI

Erlang не имеет "классического" FFI к JVM-байткоду — JVM не является разделяемой библиотекой (.so).
Вместо этого используются два официальных подхода:

| Механизм | Описание | Когда использовать |
|----------|----------|--------------------|
| **JInterface** | Java-нода = полноценный Erlang-узел (сообщения OTP) | Распределённые системы, RPC |
| **Erlang Port** | Java-процесс общается через stdin/stdout с Erlang | Простая интеграция, изоляция |
| **C NIF/Port Driver** | Только для нативного C-кода, не JVM | Максимальная производительность |
