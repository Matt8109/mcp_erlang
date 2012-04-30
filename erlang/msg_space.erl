-module(msg_space).

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

	{_, S, M} = now(),
	%% Params: (0, Number of clients, 0, Messages per Client)
	initiatespawn(0, 6, 0, 10, Messagedb, S, M),
	
	% Simple message return test
	%returnmessage("Bonda", "hi ", Messagedb).
	%Messagedb ! {exit},

	io:format(" - Spawning Completed - ~n", []).

%% Spawn out clients 
%% UsrSt, UsrFin  : User number start, finish 
%% 	  	    (so (0, 6) makes 6 clients)
%% CharSt, CharFin: Message number start, finish 
%% 	   	    (so (0, 10) sends 10 messages per client 

initiatespawn(UsrFin, UsrFin, _CharSt, _CharFin, _Msgdb, _S, _M) -> done;
initiatespawn(UsrSt, UsrFin, CharSt, CharFin, Msgdb, S, M) -> 
	spawn(msg_space, fireupdates, [[66,111,110,100,UsrSt], CharSt, CharFin, Msgdb,S,M] ),
	initiatespawn(UsrSt+1, UsrFin, CharSt, CharFin, Msgdb, S, M). 


%% Send out updates, and removals
fireupdates(User, End,   End, Messagedb, S, M) -> 
	undoupdates(User, 0, End, Messagedb, S, M);
fireupdates(User, Count, End, Messagedb, S, M) ->
	Messagedb ! {post, {User, [104, 105, Count]}},
	fireupdates(User, Count+1, End, Messagedb, S, M).

undoupdates(User, End,   End, _Messagedb, S, M) -> 
	{_, Ss, Mm} = now(),
	io:format("~w  Completed: ~wms~n", [User, (Ss-S)*1000000+(Mm-M)]),
	%Messagedb ! {status, User, S, M},
	done;

undoupdates(User, Count, End, Messagedb, S, M) ->
	Messagedb ! {remove, {User, [104, 105, Count]}},
	undoupdates(User, Count+2, End, Messagedb, S, M).

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
	    	  messagespace(Messages++[{User,Message}]);

	    {remove, {User, Message} } ->
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

	    {status, User, S, M} ->
	    	  {_,Ss, Mm} = now(),
	    	  io:format("~w  Completed: ~wms  Messages recieved: ~w~n", [User, (Ss-S)*1000000+(Mm-M),length(Messages)]),
		  messagespace(Messages);

	    {exit} -> done

	    end.
