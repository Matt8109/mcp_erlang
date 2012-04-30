-module(pattern_matching).
-export([go/0, receiver/0]).

go()->
 Pid = spawn(?MODULE, receiver, []), 
 Pid ! {bob, "Hello world!"}.

receiver()->
 receive
  {bob, Text}-> 
    io:format("Bob got message ~s", [Text]);
  {bob, 2, Text}-> 
    io:format("Bob two got message ~s", [Text]);
  { _, Text}->
    io:format("Eve got message ~s", [Text])
 end.
