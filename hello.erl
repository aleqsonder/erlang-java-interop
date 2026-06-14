%%! -sname hello

-module(hello).
-export([main/1]).

main([Msg]) ->
	{ok, _} = net_kernel:start([hello, shortnames]),
	Host = net_adm:localhost(),
	Node = list_to_atom("java@" ++ Host),
	pong = net_adm:ping(Node),

	Resp = {hello, Node} ! {self(), Msg},
	io:format("resp: ~p~n", [Resp]).
