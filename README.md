# lager_html
基于lager生成html文件，易于查看

简单的来说就是加了自定义的formatter和rotator,其他内容保持和lager一致


你必须把下面的内容覆盖到lager的环境变量中
```erlang
[
    {log_root, "./log"},
    {handlers, [
        {lager_file_backend,
            [
                %% 日志文件前缀，全名是 File++Date.html
                {file, "error_log"},
                %%debug=128, info=64, notice=32, warning=16, error=8, critical=4, alert=2, emergency=1, none=0
                {level, info},
                {formatter, lager_log_html_formatter},
                %% 字符串格式，可选值，使用lager_log_html_formatter后默认模板会改成以下内容
%%                    {formatter_config, ["<div><font size=\"2\" color=", html_color, ">\n== ", date, " ",
%%                        time, " ===", sev, "(", pid, module, ":", function, ":", line, ") ： ", message, "\n</font></div>"]},
                %% 每天生成新日志文件，最多保留30个
                {date, "$D0"},
                {count, 30},
                {rotator, lager_log_html_rotator}
            ]}
    ]},
    %% error_logger重定向
    {error_logger_redirect, true},

    %% crash_log
    {crash_log, "crash.log"}, %% crash.log文件名
    {crash_log_count, 5},    %% 最多保存5个crash.log文件
    {crash_log_date, "$Ml"} %% 每月最后一天生成一个新的crash.log

    %% html染色,替换lager_log_html_formatter提供的模板中的html_color字段，可选值，默认值如下
    %% {html_colors, [
    %%     {error, "\"#FF0000\""},
    %%     {warning, "\"#FFCC33\""},
    %%     {debug, "\"#00FFD2\""},
    %%     {info, "\"#00FF00\""},
    %%     {critical, "\"#6C2A6D\""}]}

]
```

可以选择在启动参数里加入 -config xx.config xx.config中的内容 {lager, KV}.  
或者在rebar.config中加入get-deps的hook，在每次拉取下来的时候重新修改lager的 lager.app.src中的默认环境变量  
不推荐在代码中调用application:set_env来实现，因为lager.app.src中会覆盖之前的内容，而且lager很多参数都是启动时生效，后续不能修改  


## 测试
在rebar.config 的erl_opts 中加入`{src_dirs, ["src", "test"]}`编译    
在项目目录下执行`erl -pa ebin deps/lager/ebin deps/goldrush/ebin -config test/lager_html_test.config`  
执行 `lager_html_test:test().`  
log目录下就会生成对应的日志文件


## 使用
也可以仿照lager_log_html_formatter和lager_log_html_rotator写两个类似的模块放到自己的工程项目中，
项目本身并没有其他扩展