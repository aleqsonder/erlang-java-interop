FROM debian:stable-slim

# Метаданные
LABEL maintainer="aleqsonder" \
      description="Erlang + Java interop demo (JInterface + Port FFI)"

# Базовые инструменты + Erlang + Java 17
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      # Системные утилиты
      curl wget git sudo procps locales \
      # Erlang/OTP
      erlang \
      erlang-jinterface \
      # Java 17
      openjdk-17-jdk \
      # Maven (сборка Java-проектов)
      maven \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем локаль
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Находим OtpErlang.jar и делаем переменную окружения доступной глобально
RUN JI=$(find /usr/lib/erlang/lib -name 'OtpErlang.jar' 2>/dev/null | head -1) && \
    echo "export JINTERFACE_JAR=${JI}" >> /etc/profile.d/erlang_jinterface.sh && \
    echo "export JINTERFACE_JAR=${JI}" >> /etc/environment

# Устанавливаем переменную для последующих RUN-слоёв
ENV JINTERFACE_JAR=/usr/lib/erlang/lib/jinterface-1.14/priv/OtpErlang.jar

# Создаём непривилегированного пользователя vscode (совместимость с VS Code Dev Containers)
RUN useradd -ms /bin/bash vscode && \
    echo 'vscode ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Запускаем epmd при старте контейнера
RUN echo 'epmd -daemon' >> /etc/bash.bashrc

USER vscode
WORKDIR /workspaces/erlang-java-interop

# Проверка установки при сборке образа
RUN erl -eval 'io:format("Erlang/OTP: ~s~n",[erlang:system_info(otp_release)]),halt().' -noshell && \
    java -version
