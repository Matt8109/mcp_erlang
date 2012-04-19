-module(msg_space).

%% Come back and specify which to export
%% -export([messagespace/3]).
%% -compile([debug_info,export_all]).
%% -compile(export_all).
-export([go/0,messagespace/1,fireupdates/6]).

-author("Saksena,Mancuso").

go() ->
     intro(),
     runsimulation().

intro() ->
	io:format("Abhishek Saksena && Matthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n~n").

runsimulation() ->
        Messagedb = spawn_link (msg_space, messagespace, [ [] ]),

	io:format(" - Client Spawning Initiated -  ~n~n", []),

	initiatespawn(0, 100, 0, 100, Messagedb).

	%takelong(1,10000000),

	%Messagedb ! {status},
	%returnmessage("Bonda", "hi ", Messagedb).

	%Messagedb ! {status},

%	Messagedb ! {retrieve, {abhishek}},
%	Messagedb ! {retrieve, {matthew }},
%	Messagedb ! {retrieve, {bourne  }},

	%Messagedb ! {exit},

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
	spawn(msg_space, fireupdates, [[66,111,110,100,UsrSt], CharSt, CharFin, Msgdb,S,M] ),
	initiatespawn(UsrSt+1, UsrFin, CharSt, CharFin, Msgdb). 


%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb, S, M) -> 
	undoupdates(User, 0, End, Messagedb, S, M);
fireupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      Messagedb ! {post, {User, [104, 105, Count]}},
	      fireupdates(User, Count+1, End, Messagedb, S, M)
	end.

undoupdates(User, End,   End, Messagedb, S, M) -> 
	{_, Ss, Mm} = now(),
	io:format("~w last post: ~ws, ~wms~n", [User,Ss-S,Mm-M]),
	%% Careful of next line
	Messagedb ! {status},
	done;
undoupdates(User, Count, End, Messagedb, S, M) ->
	receive 
	after 0 ->
	      Messagedb ! {remove, {User, [104, 105, Count]}},
	      undoupdates(User, Count+2, End, Messagedb, S, M)
	end.

%% Test destructive read
returnmessage(User, Message, Messagedb) ->
	Messagedb ! {read, {User, Message}, self()},

	receive
	      {removed, Usr, Msg} ->
	      	     io:format("Received: ~p: ~p", [Usr, Msg])
	end.

%% messagespace -- The underlying Tuple Space
%% -> Add a message ( {User, Message} ), 
%% -> Remove a message ( {User, Message} ),
%% -> Collect messages member ( {User} )

messagespace(Messages) ->
	    receive

	    % Formats in which we can recieve messages
	    {post, {User, Message} } ->
%%	          io:format(" ~w ~w ~w ", [post,User,Message]),
%%	      	  io:format(" ~w ~n ", [Messages]),
	    	  messagespace(Messages++[{User,Message}]);

	    {remove, {User, Message} } ->
%	     	  io:format(" ~w ~n ", [Messages]),
		  messagespace(Messages--[{User,Message}]);

	    {read, {User, Message}, Sender } ->
	    	  Sender ! {removed, User, Message }, 
		  messagespace(Messages--[{User,Message}]);

	    {retrieve, {User} } ->
	    	  io:format("~w posted the following messages: ~n~p~n~n", [User,[X || {Y, X} <- Messages, Y =:= User]]),
		  messagespace(Messages);

	    {printall} ->
   	  	  io:format("~nAll Messages: ~p ~n~n", [Messages]),
		  messagespace(Messages);

	    {status} ->
	    	  io:format("~nMessages recieved: ~w~n", [length(Messages)]),
		  messagespace(Messages);

	    {exit} -> done

	    end.