-module(messageordering).
-export([go/0, receiver/0]).

go() ->
  Pid = spawn(?MODULE, receiver, []),
  Pid ! { second_message },
  Pid ! { first_message}.  

receiver() ->
  receive
    { first_message } -> 
      io:format("\nGot First")
  end,
  receive
    { second_message } -> 
      io:format("\nGot Second\n")
  end.