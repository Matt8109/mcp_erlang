-module(msg_space).

%% Come back and specify which to export
%% -export([messagespace/3]).
%% -compile([debug_info,export_all]).
%% -compile(export_all).
-export([go/0,messagespace/1,fireupdates/4]).

-author("Saksena,Mancuso").

go() ->
     intro(),
     runsimulation().

intro() ->
	io:format("Abhishek Saksena && Matthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n~n").

runsimulation() ->
        Messagedb = spawn_link (msg_space, messagespace, [ [] ]),

	spawn( msg_space, fireupdates, [abhishek, 32,  82, Messagedb] ),
	spawn( msg_space, fireupdates, [matthew , 52, 102, Messagedb] ),
	spawn( msg_space, fireupdates, [draper  , 76, 126, Messagedb] ),
	spawn( msg_space, fireupdates, [durden  , 46,  96, Messagedb] ),
	spawn( msg_space, fireupdates, [bond    , 60, 110, Messagedb] ),
	spawn( msg_space, fireupdates, [bourne  , 68, 118, Messagedb] ),

	io:format(" - Updates Spawned - ~n", []),

	takelong(1,10000000),

	Messagedb ! {status},

	Messagedb ! {retrieve, {abhishek}},
	Messagedb ! {retrieve, {matthew }},
	Messagedb ! {retrieve, {bourne  }},

	Messagedb ! {exit},

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
	      Messagedb ! {post, {User, [87,101,108,99,111,109,101,95,Count]}},
	      fireupdates(User, Count+1, End, Messagedb)
	end.

undoupdates(_User, End,   End, _Messagedb) -> done;
undoupdates(User, Count, End, Messagedb) ->
	receive 
	after 0 ->
	      % Welcome + Count
	      Messagedb ! {remove, {User, [87,101,108,99,111,109,101,95,Count]}},
	      undoupdates(User, Count+2, End, Messagedb)
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

	    {retrieve, {User} } ->
	    	  io:format("~w posted the following messages: ~n~p~n~n", [User,[X || {Y, X} <- Messages, Y =:= User]]),
		  messagespace(Messages);

	    {status} ->
   	  	  io:format("~nAll Messages: ~p ~n~n", [Messages]),
		  messagespace(Messages);

	    {exit} -> done

	    end.