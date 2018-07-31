-module(er_table).

-export([init/0, add_route/4, get_route/2, remove_route/2]).

init() ->
    gb_trees:empty().

add_route(Dest, Neigh, Len, Table) ->
    gb_trees:enter(Dest, {Neigh, Len}, Table).

get_route(Dest, Table) ->
    gb_trees:lookup(Dest, Table).

remove_route(Dest, Table) ->
    gb_trees:delete_any(Dest, Table).

