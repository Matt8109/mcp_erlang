-module(msg_space).

%% Come back and specify which to export
%% -export([messagespace/3]).
%% -compile([debug_info,export_all]).
-compile(export_all).


-author("Saksena,Mancuso").

intro() ->
	io:format("Abhishek Saksena,~nMatthew Mancuso~n"),
	io:format("Distributed Computing -- Spring 2012, Lerner~n").


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

	    {retrieve, {User} } ->
	    	  io:format("~w posted the following messages: ~n~w", [User,[X || {User, X} <- Messages]])

	    end.