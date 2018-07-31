-module(main).

-export([main/0]).

process_lines(Device, Parser) ->
    process_lines_i(Device, Parser, []).

process_lines_i(Device, Parser, List) ->
    case io:get_line(Device, "") of
        eof -> List;
        Line -> Result = Parser(Line),
                process_lines_i(Device, Parser, [Result] ++ List)
    end.

extract_data(Line) ->
    [NodeName, RawNeighbours] = string:tokens(Line, " "),
    NeighbourList = string:tokens(clean(RawNeighbours), ","),
    {NodeName, NeighbourList}.

clean(Text) ->
    re:replace(Text, "(^\\s+)|(\\s+$)", "", [global,{return,list}]).

main() ->
    %%{ok, Device} = file:open("./res/net.top", [read]),
    %%Data = process_lines(Device, fun(Line) -> extract_data(Line) end),
    %%io:format("~p", [Data]).
    Child = spawn(er_node, start, [[]]),
    Child ! {debug, {get_routes, []}}.

