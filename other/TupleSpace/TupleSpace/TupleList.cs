using System;
using System.Collections.Generic;

namespace TupleSpace
{
	public class TupleList
	{
		
		public TupleList ()
		{
			SyncRoot = new object();
			TupleList = new List<Tuple>();
		}
		
		public Object SyncRoot {get; private set;}
		public List<Tuple> List {get; private set;}
	}
}

