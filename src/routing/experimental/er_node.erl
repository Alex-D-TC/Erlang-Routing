-module(er_node).

-export([start/2]).

-record(node_state, {name, table, neighbors, route_requests}).

% Message structure -> (message_type, payload)

start(Name, Neighbors) ->
    Table = init_state(),
    run(#node_state{name=Name, table=Table, neighbors=Neighbors, route_requests=orddict:new()}).

init_state() ->
    er_table:init().

run(NodeState) ->
    receive
        {protocol, Msg} ->
            N_State = handle_protocol(NodeState, Msg),
            run(N_State);

        {debug, Msg} ->
            N_State = handle_debug(NodeState, Msg),
            run(N_State);
        
        {quit, _} ->
            ok
    end.

handle_protocol(NodeState, Msg) ->
    handle_protocol_internal(NodeState, Msg).

handle_protocol_internal(NodeState, {route_request, {Sender, Dest, Hops} }) ->
    Table = NodeState#node_state.table,
    case er_table:get_route(Dest, Table) of
       none ->
           %% Request the route myself from my neighbors
           "";
        {Neigh, Len} ->
            Sender ! {route_reply, {Neigh, Len + 1}}
    end,

    NodeState;

handle_protocol_internal(NodeState, {route_reply, {SendingNeighbor, Dest, Len} }) ->
    Table = NodeState#node_state.table,
    N_Table = er_table:add_route(SendingNeighbor, Dest, Len, Table),
    
    NodeState#node_state{table=N_Table};

handle_protocol_internal(NodeState, {route_data, {Dest, Payload} }) ->
    Table = NodeState#node_state.table,
    Name = NodeState#node_state.name,

    case Dest == Name of
        true ->
            %% Data is for me :>. Log it, I guess?
            ok;
        false ->
            case er_table:get_route(Dest, Table) of
                none ->
                    %% Cannot send it anywhere. Drop for now
                    ok;
                {Neigh, _} ->
                    Neigh ! {route_data, {Dest, Payload}}    
            end
    end,
    
    NodeState.

handle_debug(NodeState, Msg) ->
    handle_debug_internal(NodeState, Msg).    

handle_debug_internal(NodeState, {get_routes, _}) ->
    Table = NodeState#node_state.table,
    io:format("Routing data: ~p ~n", [gb_trees:to_list(Table)]),
    
    NodeState.
