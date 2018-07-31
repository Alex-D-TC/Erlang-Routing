-module(main).

-export([main/0]).

main() ->
    Child = spawn(er_node, start, []),
    Child ! {quit, {get_routes, []}}.

