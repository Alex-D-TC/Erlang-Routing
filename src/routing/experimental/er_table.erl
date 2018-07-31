-module(er_table).

-export([init/0, add_route/3, get_route/2, remove_route/2]).

init() ->
    gb_trees:empty().

add_route(Neigh, Len, Table) ->
    gb_trees:enter(Neigh, Len, Table).

get_route(Neigh, Table) ->
    gb_trees:lookup(Neigh, Table).

remove_route(Neigh, Table) ->
    gb_trees:delete_any(Neigh, Table).

