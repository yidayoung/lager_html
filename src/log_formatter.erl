%%%-------------------------------------------------------------------
%%% @author wangyida
%%% @copyright (C) 2019, <SKYMOONS>
%%% @doc
%%%
%%% @end
%%% Created : 20. 九月 2019 15:49
%%%-------------------------------------------------------------------
-module(log_formatter).


%% API
-export([format/2, format/3]).

-define(COLORS, [
    {error, "\"#FF0000\""},
    {warning, "\"#FFCC33\""},
    {debug, "\"#00FFD2\""},
    {info, "\"#00FF00\""},
    {critical, "\"#6C2A6D\""}
]).

-define(OTHER_COLOUR, "\"#50CCFF\"").

format(Msg, Config) ->
    format(Msg, Config, []).

format(Message, Config, Colors) ->
    Config1 = [case V of
                   html_color ->
                       output_color(Message, ?COLORS);
                   _ ->
                       V
               end || V <- Config],
    lager_default_formatter:format(Message, Config1, Colors).

output_color(_Msg, []) ->
    [];
output_color(Msg, Colors) ->
    Level = lager_msg:severity(Msg),
    case lists:keyfind(Level, 1, Colors) of
        {_, Color} ->
            Color;
        _ ->
            ?OTHER_COLOUR
    end.

