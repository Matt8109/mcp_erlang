-module(helloworld).
-export([go/0, reciever/0]).

go()->
 Pid = spawn(?MODULE, reciever, []),
 Pid ! {msg, "Helo world!"}.
	
reciever()->
 receive
 	{msg, Text} -> io:format("~n Message Recieved: ~s ~n ", [Text])
 end.