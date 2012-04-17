-module(msg_space).

%% Come back and specify which to export
%% -export([messagespace/3]).
%% -compile([debug_info,export_all]).
%% -compile(export_all).
-export([go/0, intro/0, runsimulation/0,messagespace/1]).

-author("Saksena,Mancuso").

go() ->
     intro(),
     runsimulation().

intro() ->
	io:format("Abhishek Saksena && Matthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n~n").

runsimulation() ->
        Posts = spawn_link (msg_space, messagespace, [ [] ]),
	%register (Posts, MessageDB), 
	Posts ! {post, {abhishek, "Welcome1"}},
	Posts ! {post, {abhishek, "Welcome2"}},
	Posts ! {post, {abhishek, "Welcome3"}},
	Posts ! {post, {abhishek, "Welcome4"}},
	Posts ! {post, {matthew , "Hello, world1"}},
	Posts ! {post, {matthew , "Hello, world2"}},
	Posts ! {post, {matthew , "Hello, world3"}},
	Posts ! {post, {matthew , "Hello, world4"}},

	Posts ! {status},

	Posts ! {remove, {matthew , "Hello, world1"}},
	Posts ! {remove, {abhishek, "Welcome1"}},

	Posts ! {status},

	Posts ! {retrieve, {abhishek}},
	Posts ! {retrieve, {matthew }},

	Posts ! {exit},

	io:format(" - Simulation Completed - ~n", []).

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
	    	  io:format("~w posted the following messages: ~n~w~n~n", [User,[X || {Y, X} <- Messages, Y =:= User]]),
		  messagespace(Messages);

	    {status} ->
	    	  io:format("~nAll Messages: ~w ~n~n", [Messages]),
		  messagespace(Messages);

	    {exit} -> done

	    end.