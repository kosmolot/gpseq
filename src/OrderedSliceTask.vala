/* OrderedSliceTask.vala
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
	 * A fork-join task that performs an ordered slice operation.
	 */
	internal class OrderedSliceTask<G> : ShortCircuitTask<G,ArrayBuffer<G>> {
		private const long CHECK_INTERVAL = 8192; // 1 << 13

		private int _skip; // never changed
		private int _limit; // never changed
		private AtomicIntRef _size;
		private AtomicBoolRef _completed;

		/**
		 * Creates a new ordered slice task.
		 * @param spliterator a spliterator that may or may not be a container
		 * @param parent the parent of the new task
		 * @param skip the number of elements to skip
		 * @param limit maximum number of elements the spliterator may contain,
		 * or a negative value if unlimited
		 * @param threshold sequential computation threshold
		 * @param max_depth max task split depth. unlimited if negative
		 * @param executor an executor that will invoke the task
		 */
		public OrderedSliceTask (Spliterator<G> spliterator, OrderedSliceTask<G>? parent,
				int skip, int limit,
				int threshold, int max_depth, Executor executor)
		{
			base(spliterator, parent, threshold, max_depth, executor);
			_skip = skip;
			_limit = limit;
			_size = new AtomicIntRef(0);
			_completed = new AtomicBoolRef(false);
		}

		protected override Optional<ArrayBuffer<G>> empty_result {
			owned get {
				return new Optional<ArrayBuffer<G>>.of( new ArrayBuffer<G>({}) );
			}
		}

		protected override Optional<ArrayBuffer<G>> leaf_compute () {
			G[] array = _limit < 0 ? copy_elements() : copy_limited_elements();
			ArrayBuffer<G> buffer = new ArrayBuffer<G>((owned) array);
			if (is_root) {
				buffer = chop(buffer);
				var result = new Optional<ArrayBuffer<G>>.of(buffer);
				short_circuit(result);
				return result;
			} else {
				_size.val = buffer.size;
				_completed.val = true;
				check_target_size();
				return new Optional<ArrayBuffer<G>>.of(buffer);
			}
		}

		protected override Optional<ArrayBuffer<G>> merge_results (
				Optional<ArrayBuffer<G>> left, Optional<ArrayBuffer<G>> right) {
			ArrayBuffer<G> array;
			int size = left.value.size + right.value.size;
			if (size == 0 || is_canceled) {
				_size.val = 0;
				array = new ArrayBuffer<G>({});
			} else if (left.value.size == 0) {
				_size.val = size;
				array = right.value;
			} else {
				_size.val = size;
				array = new ConcatArrayBuffer<G>(left.value, right.value);
			}

			if (is_root) {
				array = chop(array);
				var result = new Optional<ArrayBuffer<G>>.of(array);
				short_circuit(result);
				return result;
			} else {
				_completed.val = true;
				check_target_size();
				return new Optional<ArrayBuffer<G>>.of(array);
			}
		}

		protected override ShortCircuitTask<G,ArrayBuffer<G>> make_child (Spliterator<G> spliterator) {
			var task = new OrderedSliceTask<G>(spliterator, this, _skip, _limit, threshold, max_depth, executor);
			task.depth = depth + 1;
			return task;
		}

		private void check_target_size () {
			if (_limit >= 0 && is_left_completed) {
				cancel_later_nodes();
			}
		}

		private G[] copy_elements () {
			int size = int.max(0, spliterator.estimated_size);
			G[] array = new G[size];
			int idx = 0;
			spliterator.each((g) => {
				if (idx >= array.length) {
					array.resize( next_pot(idx) );
				}
				array[idx++] = g;
			});
			if (array.length != idx) array.resize(idx);
			return array;
		}

		private G[] copy_limited_elements () {
			int size = int.max(0, spliterator.estimated_size);
			G[] array = new G[size];
			int idx = 0;
			long chk = 0;
			spliterator.each_chunk((chunk) => {
				for (int i = 0; i < chunk.length; i++) {
					if (idx >= array.length) {
						array.resize( next_pot(idx) );
					}
					array[idx++] = chunk[i];
				}
				_size.val = idx;
				chk += chunk.length;
				if (chk > CHECK_INTERVAL) {
					chk = 0;
					if (is_canceled || is_left_completed) {
						return false;
					}
				}
				return true;
			});
			if (array.length != idx) array.resize(idx);
			return array;
		}

		/**
		 * Finds next power of two, which is greater than and not equal to n.
		 * @return next power of two, which is greater than and not equal to n
		 */
		private inline int next_pot (int n) {
			int v = 1;
			while (v <= n) {
				v = v << 1;
			}
			return v;
		}

		private ArrayBuffer<G> chop (ArrayBuffer<G> array) {
			int start = int.min(array.size, _skip);
			int stop = _limit < 0 ? array.size : int.min(array.size, _skip + _limit);
			return array.slice(start, stop);
		}

		private bool is_left_completed {
			get {
				// assert(_limit >= 0);
				int target = _skip + _limit;
				int size = _completed.val ? _size.val : calc_completed_size(target);
				if (size >= target) return true;
				OrderedSliceTask<G>? p = (OrderedSliceTask<G>?) parent;
				OrderedSliceTask<G> cur = this;
				while (p != null) {
					if (cur == p.right_child) {
						size += ((OrderedSliceTask<G>) p.left_child).calc_completed_size(target);
						if (size >= target) return true;
					}
					cur = p;
					p = (OrderedSliceTask<G>?) p.parent;
				}
				return size >= target;
			}
		}

		private int calc_completed_size (int target) {
			if (_completed.val) {
				return _size.val;
			} else {
				OrderedSliceTask<G>? left = (OrderedSliceTask<G>?) left_child;
				OrderedSliceTask<G>? right = (OrderedSliceTask<G>?) right_child;
				if (right == null) { // leaf node
					return _size.val;
				} else {
					int left_size = left.calc_completed_size(target);
					if (left_size >= target) {
						return left_size;
					} else {
						return left_size + right.calc_completed_size(target);
					}
				}
			}
		}
	}
}
