using System;
using System.Linq;
using System.Collections.Generic;

namespace TupleSpace
{
	public class TupleSpace
	{
		private Hashtable tupleSpace;
		private Object syncRoot;
		
		public TupleSpace ()
		{
			tupleSpace = new Hashtable(); 
			syncRoot = new object();
		}
		
		/// <summary>
		/// Adds a tuple with a specific atom to the tuple space.
		/// </summary>
		/// <param name='tuple'>
		/// Tuple.
		/// </param>
		public void AddTuple(Tuple tuple) {
			TupleList tupleList;
			
			lock (syncRoot) {
				if (tupleSpace[tuple.Atom] == null)
						tupleSpace[tuple.Atom] = new TupleList();
				
				tupleList = tupleSpace[tuple.Atom];	
			}
			
			lock(tupleList.SyncRoot) {
				tupleList.List.Add(tuple);
			}
		}
		
		/// <summary>
		/// Gets the tuples.
		/// </summary>
		/// <returns>
		/// The tuples.
		/// </returns>
		/// <param name='atom'>
		/// Atom.
		/// </param>
		public List<Tuple> GetTuples(String atom) {
			TupleList tupleList;
			List<Tuple> returnList = null;
			
			// grab the tuples from the space
			lock (syncRoot) {
				var result = tupleSpace[tuple.Atom];
				
				if (result!=null)
					tupleList = (TupleList) result;
				else
					tupleList = new TupleList();
			}
			
			lock (tupleList.SyncRoot) {
				tupleList.List.ForEach(x => returnList.Add(x));
			}
			
			return returnList;
		}
		
		/// <summary>
		/// Remove the specified tuple.
		/// </summary>
		/// <param name='tuple'>
		/// If set to <c>true</c> tuple.
		/// </param>
		public bool Remove(Tuple tuple) {
			bool existed = false;
			
			lock (syncRoot) {
				var result = tupleSpace[tuple.Atom];
				
				if (result!=null) {
					existed = true;
					tupleSpace[tuple.Atom] = null;
				}
			}
			
			return existed;
		}
	}
}

