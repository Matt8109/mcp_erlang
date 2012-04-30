{module, pattern_matching}.  %% version = 0

{exports, [{go,0},{module_info,0},{module_info,1},{receiver,0}]}.

{attributes, []}.

{labels, 15}.


{function, go, 0, 2}.
  {label,1}.
    {line,[{location,"pattern_matching.erl",4}]}.
    {func_info,{atom,pattern_matching},{atom,go},0}.
  {label,2}.
    {allocate,0,0}.
    {move,{atom,receiver},{x,1}}.
    {move,nil,{x,2}}.
    {move,{atom,pattern_matching},{x,0}}.
    {line,[{location,"pattern_matching.erl",5}]}.
    {call_ext,3,{extfunc,erlang,spawn,3}}.
    {move,{literal,{bob,"Hello world!"}},{x,1}}.
    {line,[{location,"pattern_matching.erl",6}]}.
    send.
    {deallocate,0}.
    return.


{function, receiver, 0, 4}.
  {label,3}.
    {line,[{location,"pattern_matching.erl",8}]}.
    {func_info,{atom,pattern_matching},{atom,receiver},0}.
  {label,4}.
    {line,[{location,"pattern_matching.erl",9}]}.
  {label,5}.
    {loop_rec,{f,10},{x,0}}.
    {test,is_tuple,{f,9},[{x,0}]}.
    {select_tuple_arity,{x,0},{f,9},{list,[2,{f,6},3,{f,8}]}}.
  {label,6}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {get_tuple_element,{x,0},1,{x,2}}.
    {test,is_eq_exact,{f,7},[{x,1},{atom,bob}]}.
    remove_message.
    {test_heap,2,3}.
    {put_list,{x,2},nil,{x,1}}.
    {move,{literal,"Bob got message ~s"},{x,0}}.
    {line,[{location,"pattern_matching.erl",11}]}.
    {call_ext_only,2,{extfunc,io,format,2}}.
  {label,7}.
    remove_message.
    {test_heap,2,3}.
    {put_list,{x,2},nil,{x,1}}.
    {move,{literal,"Eve got message ~s"},{x,0}}.
    {line,[{location,"pattern_matching.erl",15}]}.
    {call_ext_only,2,{extfunc,io,format,2}}.
  {label,8}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {get_tuple_element,{x,0},1,{x,2}}.
    {get_tuple_element,{x,0},2,{x,3}}.
    {test,is_eq_exact,{f,9},[{x,1},{atom,bob}]}.
    {test,is_eq_exact,{f,9},[{x,2},{integer,2}]}.
    remove_message.
    {test_heap,2,4}.
    {put_list,{x,3},nil,{x,1}}.
    {move,{literal,"Bob two got message ~s"},{x,0}}.
    {line,[{location,"pattern_matching.erl",13}]}.
    {call_ext_only,2,{extfunc,io,format,2}}.
  {label,9}.
    {loop_rec_end,{f,5}}.
  {label,10}.
    {wait,{f,5}}.


{function, module_info, 0, 12}.
  {label,11}.
    {line,[]}.
    {func_info,{atom,pattern_matching},{atom,module_info},0}.
  {label,12}.
    {move,{atom,pattern_matching},{x,0}}.
    {line,[]}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 14}.
  {label,13}.
    {line,[]}.
    {func_info,{atom,pattern_matching},{atom,module_info},1}.
  {label,14}.
    {move,{x,0},{x,1}}.
    {move,{atom,pattern_matching},{x,0}}.
    {line,[]}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.
