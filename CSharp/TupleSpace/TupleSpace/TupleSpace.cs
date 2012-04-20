using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;

namespace TupleSpace
{
    public class TupleSpace
    {
        private readonly ReaderWriterLockSlim _syncRoot;
        private readonly Hashtable _tupleSpace;

        public TupleSpace()
        {
            _tupleSpace = new Hashtable();
            _syncRoot = new ReaderWriterLockSlim();
        }

        /// <summary>
        /// Adds a tuple with a specific atom to the tuple space.
        /// </summary>
        /// <param name='tuple'>
        /// Tuple.
        /// </param>
        public void AddTuple(Tuple tuple)
        {
            _syncRoot.EnterWriteLock();

            if (_tupleSpace[tuple.Atom] == null)
                _tupleSpace[tuple.Atom] = new TupleList();

            var tupleList = (TupleList)_tupleSpace[tuple.Atom];

            _syncRoot.ExitWriteLock();

            lock (tupleList.SyncRoot)
            {
                tupleList.List.Add(tuple);
            }
        }

        /// <summary>
        /// Gets the tuples based on an atom.
        /// </summary>
        /// <returns>
        /// The tuples.
        /// </returns>
        /// <param name='atom'>
        /// Atom.
        /// </param>
        public List<Tuple> GetTuples(String atom)
        {
            TupleList tupleList;
            List<Tuple> returnList = new List<Tuple>();

            // grab the tuples from the space

            _syncRoot.EnterReadLock();
            object result = _tupleSpace[atom];
            _syncRoot.ExitReadLock();

            if (result != null)
                tupleList = (TupleList)result;
            else
                tupleList = new TupleList();


            lock (tupleList.SyncRoot)
                tupleList.List.ForEach(returnList.Add);

            return returnList;
        }

        /// <summary>
        /// Remove the specified tuple.
        /// </summary>
        /// <param name='tuple'>
        /// If set to <c>true</c> tuple.
        /// </param>
        public bool Remove(Tuple tuple)
        {
            bool existed = false;

            _syncRoot.EnterWriteLock();

            object result = _tupleSpace[tuple.Atom];

            if (result != null)
            {
                existed = true;
                _tupleSpace[tuple.Atom] = null;
            }

            _syncRoot.ExitWriteLock();

            return existed;
        }
    }
}