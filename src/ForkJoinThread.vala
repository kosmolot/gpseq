/* ForkJoinThread.vala
 *
 * Copyright (C) 2018  kosmolot (kosmolot17@yandex.com)
 *
 * This file is part of Gpseq.
 *
 * Gpseq is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your
 * option) any later version.
 *
 * Gpseq is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
 * License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with Gpseq.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gee;

namespace Gpseq {
	/**
	 * Fork-join worker thread.
	 */
	public class ForkJoinThread : Object {
		/**
		 * A table storing fork-join threads.
		 */
		private static Map<Thread, ForkJoinThread>? threads;

		/**
		 * Gets the fork-join thread corresponding to the given thread.
		 * @return the fork-join thread corresponding to the given Thread, or
		 * null if not found
		 */
		public static ForkJoinThread? get_by (Thread thread) {
			// TODO can be improved using a concurrent hash map
			lock (threads) {
				if (threads == null) {
					threads = new HashMap<Thread, ForkJoinThread>();
				}
				return threads[thread];
			}
		}

		/**
		 * Gets the fork-join thread corresponding to the current thread.
		 * @return the fork-join thread corresponding to the current thread, or
		 * null if the current thread is not a fork-join thread
		 */
		public static ForkJoinThread? self () {
			return get_by(Thread.self<void*>());
		}

		/**
		 * Registers the fork-join thread.
		 */
		private static void set_thread (Thread k, ForkJoinThread v) {
			lock (threads) {
				if (threads == null) {
					threads = new HashMap<Thread, ForkJoinThread>();
				}
				threads[k] = v;
			}
		}

		/**
		 * Unregisters the fork-join thread corresponding to the given thread.
		 */
		private static void unset_thread (Thread k) {
			lock (threads) {
				if (threads == null) {
					threads = new HashMap<Thread, ForkJoinThread>();
				}
				threads.unset(k);
			}
		}

		private Thread<void*>? _thread = null; // also used to lock
		private unowned ForkJoinPool _pool;
		private int _id; // index in pool
		private string _name;
		private WorkQueue _work_queue;
		private QueueBalancer _balancer;
		private bool _terminated;

		/**
		 * Creates a new fork-join thread.
		 * @param pool a fork-join pool
		 */
		public ForkJoinThread (ForkJoinPool pool) {
			_pool = pool;
			_id = pool.next_thread_id();
			_name = pool.thread_name(_id);
			_work_queue = new WorkQueue();
			_balancer = new DefaultQueueBalancer();
		}

		~ForkJoinThread () {
			unset_thread(_thread);
		}

		/**
		 * The internal thread object, or null if this fork-join thread has not
		 * yet started.
		 */
		public Thread<void*>? thread {
			get {
				lock (_thread) {
					return _thread;
				}
			}
		}

		/**
		 * The fork-join pool to which this thread belongs.
		 */
		public ForkJoinPool pool {
			get {
				return _pool;
			}
		}

		/**
		 * The id of this thread in the pool.
		 */
		public int id {
			get {
				return _id;
			}
		}

		/**
		 * The name of this thread.
		 */
		public string name {
			get {
				return _name;
			}
		}

		/**
		 * The work queue of this thread.
		 */
		internal WorkQueue work_queue {
			get {
				return _work_queue;
			}
		}

		/**
		 * The queue balancer of this thread.
		 */
		internal QueueBalancer balancer {
			get {
				return _balancer;
			}
		}

		/**
		 * Whether or not this thread has been started.
		 */
		public bool is_started {
			get {
				lock (_thread) {
					return _thread != null;
				}
			}
		}

		/**
		 * Whether or not this thread has been terminated.
		 */
		public bool is_terminated {
			get {
				lock (_thread) {
					return _terminated;
				}
			}
		}

		/**
		 * Whether or not this thread is alive. a thread is alive if it has been
		 * started and has not yet terminated.
		 */
		public bool is_alive {
			get {
				lock (_thread) {
					return _thread != null && !_terminated;
				}
			}
		}

		/**
		 * Starts this thread.
		 */
		public void start () {
			lock (_thread) {
				lock (threads) {
					_thread = new Thread<void*>(_name, run);
					set_thread(_thread, this);
				}
			}
		}

		/**
		 * Queues the given task into the work queue of this thread.
		 * @param task a task to queue.
		 */
		public void push_task (ForkJoinTask task) {
			_work_queue.offer_tail(task);
		}

		/**
		 * Loop for task join.
		 */
		internal void task_join (ForkJoinTask task) throws Error {
			while (true) {
				if (_pool.is_terminating_started) return;
				if (task.is_done) return;
				balancer.tick(this, true);

				ForkJoinTask? pop = work_queue.poll_tail();
				if (pop != null) {
					pop.invoke(); // can throw an Error
					balancer.computed(this, true);
					if (pop == task) return;
				} else {
					balancer.no_tasks(this, true);
					balancer.scan(this, true);
				}
			}
		}

		/**
		 * Waits until this thread finishes.
		 * @see GLib.Thread.join
		 */
		public void join () {
			assert(is_started);
			_thread.join();
		}

		/**
		 * Thread loop function.
		 */
		private void* run () {
			_pool.work(this);
			lock (_thread) {
				_terminated = true;
				_pool.dec_terminating();
			}
			return null;
		}
	}
}
