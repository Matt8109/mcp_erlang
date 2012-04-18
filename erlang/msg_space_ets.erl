-module(msg_space_ets).

%% -compile(export_all).
-export([go/0,fireupdates/6]).

-author("Saksena,Mancuso").

go() ->
     intro(),
     runsimulation().

intro() ->
	io:format("Abhishek Saksena && Matthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n~n").

runsimulation() ->
	Messagedb = ets:new(mdb, [bag,public,named_table]),

	{_, S, M} = now(),

	spawn( msg_space_ets, fireupdates, [abhishek, 32,  82, Messagedb,S,M] ),
	spawn( msg_space_ets, fireupdates, [matthew , 52, 102, Messagedb,S,M] ),
	spawn( msg_space_ets, fireupdates, [draper  , 76, 126, Messagedb,S,M] ),
	spawn( msg_space_ets, fireupdates, [durden  , 46,  96, Messagedb,S,M] ),
	spawn( msg_space_ets, fireupdates, [bond    , 60, 110, Messagedb,S,M] ),
	spawn( msg_space_ets, fireupdates, [bourne  , 68, 118, Messagedb,S,M] ),

	io:format(" - Updates Spawned - ~n", []),

	takelong(1,10000000),

	io:format("~nMessages recieved: ~p~n", [ets:info(Messagedb, size)]),

	%%ets:lookup(Messagedb, bourne),

	io:format(" - Simulation Completed - ~n", []).

%% Empty loop
%% Used to stall while firing updates
takelong(End, End) -> done;
takelong(Start, End) ->
	takelong(Start+1,End).

%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb, S, M) -> 
	undoupdates(User, End-50, End, Messagedb, S, M);
fireupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:insert(Messagedb, {User, [87,101,108,99,111,109,101,95,Count]}),
	      fireupdates(User, Count+1, End, Messagedb, S, M)
	end.

undoupdates(_User, End,   End, _Messagedb, S, M) ->
	{_, Ss, Mm} = now(),
	io:format("~w last post: ~w, ~w~n", [_User,Ss-S,Mm-M]),
	done;

undoupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:match_delete(Messagedb, {User, [87,101,108,99,111,109,101,95,Count]}),
	      undoupdates(User, Count+2, End, Messagedb, S, M)
	end.
