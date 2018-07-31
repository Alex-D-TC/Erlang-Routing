%%%-------------------------------------------------------------------
%% @doc erlang_routing public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_routing_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    erlang_routing_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================