-module(msg_space).

%% Come back and specify which to export
-compile([debug_info,export_all]).
%% -compile(export_all).
%% -export( ).

-author("Saksena,Mancuso").

intro() ->
	io.format("Abhishek Saksena,~nMatthew Mancuso~n"),
	io.format("Distributed Computing -- Spring 2012, Lerner~n").


%% The Tuple Space

tspace(Max, Keys, Pids) ->
	    recieve

	    % Formats in which we can recieve messages
	    {put, pid, Pid} ->
	    	  tspace(Max, Keys, Pids++[Pid]);
	    