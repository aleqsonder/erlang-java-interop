-module(fib_client).
-export([main/0]).

main() ->
    %% Запускаем локальный Erlang-узел
    net_kernel:start([erlclient, shortnames]),
    erlang:set_cookie(node(), democookie),

    JavaNode = 'javanode@localhost',
    N = 10,

    io:format("[fib_client] Sending request fib(~p) to ~p~n", [N, JavaNode]),

    %% Отправляем {self(), N} зарегистрированному процессу fibserver на Java-узле
    {fibserver, JavaNode} ! {self(), N},

    receive
        {ok, Result} ->
            io:format("[fib_client] fib(~p) = ~p~n", [N, Result])
    after 5000 ->
        io:format("[fib_client] ERROR: timeout waiting for reply~n")
    end,

    init:stop().
