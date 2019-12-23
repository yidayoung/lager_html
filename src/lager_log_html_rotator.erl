%%%-------------------------------------------------------------------
%%% @author wangyida
%%% @copyright (C) 2019, <SKYMOONS>
%%% @doc
%%%
%%% @end
%%% Created : 20. 九月 2019 17:50
%%%-------------------------------------------------------------------
-module(lager_log_html_rotator).
-behavior(lager_rotator_behaviour).

%% API
-export([
    create_logfile/2, open_logfile/2, ensure_logfile/5, rotate_logfile/2
]).

create_logfile(Name, Buffer) ->
    open_logfile(Name, Buffer).

open_logfile(Name0, Buffer) ->
    Name = make_log_name(Name0),
    check_head(Name),
    lager_rotator_default:open_logfile(Name, Buffer).

ensure_logfile(Name0, FD, Inode0, Ctime0, Buffer) ->
    Name = make_log_name(Name0),
    R = lager_rotator_default:ensure_logfile(Name, FD, Inode0, Ctime0, Buffer),
    check_head(Name),
    R.

rotate_logfile(Name0, Count) ->
    Name = make_log_name(Name0),
    case filelib:file_size(Name) of
        0 ->
            write_head(Name);
        _ ->
            lager_rotator_default:rotate_logfile(Name, Count)
    end.


log_time() ->
    {{Y, Mo, D}, {H, Mi, S}} = erlang:localtime(),
    io_lib:format("~w/~w/~w ~w:~w:~w", [Mo, D, Y, H, Mi, S]).

write_head(File) ->
    Head = io_lib:format("<BODY bgcolor=\"#000000\">\n<pre>
<font color=\"#00FF00\">
<style type=\"text/css\">
    div {text-align:left;margin-left:4px;word-wrap:break-word;}
</style>
<CENTER><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\" /> <TITLE>Log</TITLE> <H3><font color=\"#FFFF97\">Log for ~s</font><br><br></CENTER>
<hr>",[log_time()]),
    file:write_file(File, Head).


check_head(File) ->
    case filelib:file_size(File) of
        0 ->
            write_head(File);
        _ ->
            ignore
    end.

make_log_name(PreFix) ->
    {{Year, Month, Day}, {_Hour, _Minute, _Second}} = erlang:localtime(),
    io_lib:format("~s_~p_~p_~p.html", [PreFix, Year, Month, Day]).