%%%-------------------------------------------------------------------
%%% @author wangyida
%%% @copyright (C) 2019, <SKYMOONS>
%%% @doc
%%%
%%% @end
%%% Created : 20. 九月 2019 15:49
%%%-------------------------------------------------------------------
-module(lager_log_html_formatter).


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

-define(DEFAULT_FORMAT, ["<div><font size=\"2\" color=", html_color, ">\n== ", date, " ",
    time, " ===", sev, "(", pid, module, ":", line, ") ： ", message, "\n</font></div>"]).

format(Msg, Config) ->
    format(Msg, Config, []).

format(Message, Config, Colors) ->
    Config1 = ensure_config(Config),
    HtmlColors = ensure_htmlColors(),
    Config2 = [case V of
                   html_color ->
                       output_color(Message, HtmlColors);
                   _ ->
                       V
               end || V <- Config1],
    lager_default_formatter:format(Message, Config2, Colors).

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



ensure_config([_|_] = C) ->
    C;
ensure_config(_) ->
    ?DEFAULT_FORMAT.

ensure_htmlColors() ->
    case application:get_env(lager, html_colors) of
        {ok, [_|_] = Colors} ->
            Colors;
        _ ->
            ?COLORS
    end.