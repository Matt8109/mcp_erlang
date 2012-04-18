-module(msg_space_ets).

%% -compile(export_all).
-export([go/0,fireupdates/4]).

-author("Saksena,Mancuso").

go() ->
     intro(),
     runsimulation().

intro() ->
	io:format("Abhishek Saksena && Matthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n~n").

runsimulation() ->
	%Messagedb = spawn_link ( msg_space_ets, 
	Messagedb = ets:new(messagedb, [bag, {write_concurrency}]),

	ets:insert(Messagedb, {test, test}),

	spawn( msg_space_ets, fireupdates, [abhishek, 32,  82, Messagedb] ),
	spawn( msg_space_ets, fireupdates, [matthew , 52, 102, Messagedb] ),
	spawn( msg_space_ets, fireupdates, [draper  , 76, 126, Messagedb] ),
	spawn( msg_space_ets, fireupdates, [durden  , 46,  96, Messagedb] ),
	spawn( msg_space_ets, fireupdates, [bond    , 60, 110, Messagedb] ),
	spawn( msg_space_ets, fireupdates, [bourne  , 68, 118, Messagedb] ),

	io:format(" - Updates Spawned - ~n", []),

	takelong(1,10000000),

	io:format("~nMessages recieved: ~p~n", [ets:info(Messagedb, size)]),

	ets:lookup(Messagedb, bourne),

	io:format(" - Simulation Completed - ~n", []).

%% Empty loop
%% Used to stall while firing updates
takelong(End, End) -> done;
takelong(Start, End) ->
	takelong(Start+1,End).

%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb) -> 
	undoupdates(User, End-50, End, Messagedb);
fireupdates(User, Count, End, Messagedb) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:insert(Messagedb, {User, [87,101,108,99,111,109,101,95,Count]}),
	      fireupdates(User, Count+1, End, Messagedb)
	end.

undoupdates(_User, End,   End, _Messagedb) -> done;
undoupdates(User, Count, End, Messagedb) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:delete(Messagedb, {User, [87,101,108,99,111,109,101,95,Count]}),
	      undoupdates(User, Count+2, End, Messagedb)
	end.
