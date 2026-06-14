-module(port_driver).
-export([start/0, call/2, stop/1]).

%%% Запуск Java-процесса как Erlang Port
start() ->
    %% Java-процесс должен быть скомпилирован заранее
    JarPath = os:getenv("JINTERFACE_JAR", ""),
    JavaCmd = case JarPath of
        "" -> "java -cp port_ffi/java_port PortServer";
        _  -> "java -cp port_ffi/java_port PortServer"
    end,
    Port = open_port({spawn, JavaCmd},
                     [{packet, 2}, binary, use_stdio, exit_status]),
    io:format("[port_driver] Port opened: ~p~n", [Port]),
    Port.

%%% Отправка команды и получение ответа
call(Port, Request) ->
    Bin = list_to_binary(Request),
    port_command(Port, Bin),
    receive
        {Port, {data, Data}} ->
            binary_to_list(Data)
    after 5000 ->
        timeout
    end.

%%% Остановка порта
stop(Port) ->
    port_close(Port).

main() ->
    io:format("[port_driver] Запуск Java Port...~n"),
    Port = start(),
    timer:sleep(300),

    Tests = [{"fib", 10}, {"fib", 15}, {"fact", 5}, {"fact", 10}],
    lists:foreach(fun({Op, N}) ->
        Req = Op ++ ":" ++ integer_to_list(N),
        io:format("[port_driver] Request: ~s~n", [Req]),
        Reply = call(Port, Req),
        io:format("[port_driver] Reply:   ~s~n", [Reply])
    end, Tests),

    stop(Port),
    io:format("[port_driver] Done.~n").
