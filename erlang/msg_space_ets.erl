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

	{_, S, M} = now(),
	%% Params: (0, Number of clients, 0, Messages per Client)
	initiatespawn(0, 6, 0, 10, Messagedb, S, M),

	io:format(" - Spawning Completed - ~n", []).


%% Spawn out clients 
%% UsrSt, UsrFin  : User number start, finish 
%% 	  	    (so (0, 6) makes 6 clients)
%% CharSt, CharFin: Message number start, finish 
%% 	   	    (so (0, 10) sends 10 messages per client 

initiatespawn(UsrFin, UsrFin, _CharSt, _CharFin, _Msgdb, _S, _M) -> done;
initiatespawn(UsrSt, UsrFin, CharSt, CharFin, Msgdb, S, M) -> 
	spawn(msg_space_ets, fireupdates, [[66,111,110,100,UsrSt], CharSt, CharFin, Msgdb,S,M] ),
	initiatespawn(UsrSt+1, UsrFin, CharSt, CharFin, Msgdb, S, M). 

%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb, S, M) -> 
	undoupdates(User, 0, End, Messagedb, S, M);
fireupdates(User, Count, End, Messagedb, S, M) ->
	% Welcome + Count
	ets:insert(Messagedb, {User, [87,98, Count]}),
	fireupdates(User, Count+1, End, Messagedb, S, M).

undoupdates(User, End,   End, _Messagedb, S, M) ->
	{_, Ss, Mm} = now(),
	io:format("~w  Completed: ~wms~n", [User,(Ss-S)*1000000+(Mm-M)]),
	done;

undoupdates(User, Count, End, Messagedb, S, M) ->
	% Welcome + Count
	ets:match_delete(Messagedb, {User, [87,98,Count]}),
	undoupdates(User, Count+2, End, Messagedb, S, M).
	
