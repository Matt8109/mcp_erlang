-module(msg_space_ets).

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

	io:format(" - Client Spawning Initiated -  ~n~n", []),

	%% (0, Number of clients, 0, Messages per Client)
	initiatespawn(0, 5, 0, 50, Messagedb).

	%io:format(" - Updates Spawned - ~n", []),
	%takelong(1,10000000),
	%io:format("~nMessages recieved: ~p~n", [ets:info(Messagedb, size)]),
	%%ets:lookup(Messagedb, bourne),
	%io:format(" - Simulation Completed - ~n", []).

%% Empty loop
%% Used to stall while firing updates
takelong(End, End) -> done;
takelong(Start, End) ->
	takelong(Start+1,End).

%% Spawn out 
initiatespawn(UsrFin, UsrFin, _CharSt, _CharFin, _Msgdb) -> done;
initiatespawn(UsrSt, UsrFin, CharSt, CharFin, Msgdb) -> 
	{_, S, M} = now(),
	spawn(msg_space_ets, fireupdates, [[66,111,110,100,UsrSt], CharSt, CharFin, Msgdb,S,M] ),
	initiatespawn(UsrSt+1, UsrFin, CharSt, CharFin, Msgdb). 

%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb, S, M) -> 
	undoupdates(User, 0, End, Messagedb, S, M);
fireupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:insert(Messagedb, {User, [87,98, Count]}),
	      fireupdates(User, Count+1, End, Messagedb, S, M)
	end.

undoupdates(User, End,   End, Messagedb, S, M) ->
	{_, Ss, Mm} = now(),
	io:format("~w last post: ~wms    Messages: ~p~n", [User,(Ss-S)*1000000+(Mm-M), ets:info(Messagedb, size)]),
	done;

undoupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      ets:match_delete(Messagedb, {User, [87,98,Count]}),
	      undoupdates(User, Count+2, End, Messagedb, S, M)
	end.
