%%%-------------------------------------------------------------------
%%% @author wangyida
%%% @copyright (C) 2019
%%% @doc
%%%
%%% @end
%%% Created : 09. 十月 2019 16:52
%%%-------------------------------------------------------------------
-module(lager_html_test).


%% API
-export([test/0]).


test() ->
    application:ensure_all_started(lager_html),
    lager:error("error msg"),
    lager:warning("warning msg"),
    lager:debug("debug msg"),
    lager:info("info msg"),
    lager:critical("critical msg"),
    erlang:spawn_link(fun() -> erlang:throw("this is test") end).