-module('FactorialServer').
-export([start/0, loop/1]).

fact(0) -> 1;
fact(N) when N > 0 -> N * fact(N - 1).

start() ->
    net_kernel:start([erlserver, shortnames]),
    erlang:set_cookie(node(), democookie),
    Pid = spawn(fun() -> loop(0) end),
    register(factorial_server, Pid),
    io:format("[FactorialServer] Node: ~p  PID: ~p~n", [node(), Pid]),
    io:format("[FactorialServer] Registered as 'factorial_server', waiting...~n"),
    %% Ждём, пока процесс не завершится
    receive
        stop -> ok
    end.

loop(Count) ->
    receive
        {From, N} ->
            Result = fact(N),
            io:format("[FactorialServer] fact(~p) = ~p  (request #~p)~n",
                      [N, Result, Count + 1]),
            From ! {ok, Result},
            loop(Count + 1);
        stop ->
            io:format("[FactorialServer] Stopping after ~p requests.~n", [Count])
    after 8000 ->
        io:format("[FactorialServer] Timeout, shutting down.~n")
    end.
