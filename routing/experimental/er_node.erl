-module(er_node).

-export([start/0]).

% Message structure -> (message_type, payload)

start() ->
    Table = init_state(),
    run(Table).

init_state() ->
    er_table:init().

run(Table) ->
    receive
        {protocol, Msg} ->
            N_Table = handle_protocol(Table, Msg),
            run(N_Table);
        {debug, Msg} ->
            N_Table = handle_debug(Table, Msg),
            run(N_Table);
        {quit, _} ->
            ok
    end.

handle_protocol(Table, Msg) ->
    Table.

handle_debug(Table, Msg) ->
    handle_debug_internal(Table, Msg).    

handle_debug_internal(Table, {get_routes, _}) ->
    io:format("Routing data: ~p ~n", [gb_trees:to_list(Table)]),
    Table.

