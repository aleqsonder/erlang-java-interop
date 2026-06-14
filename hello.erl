-module(hello).
-export([hello/0]).

hello() ->
	io:format("Hello from Erlang!~n").

main(_Args) ->
	hello().
