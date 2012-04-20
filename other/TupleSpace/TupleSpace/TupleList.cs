using System;
using System.Collections.Generic;

namespace TupleSpace
{
    /// <summary>
    /// Holds a list of tuples in the tuple space.
    /// </summary>
    public class TupleList
    {
        public TupleList()
        {
            SyncRoot = new object();
            List = new List<Tuple>();
        }

        public Object SyncRoot { get; private set; }
        public List<Tuple> List { get; private set; }
    }
}