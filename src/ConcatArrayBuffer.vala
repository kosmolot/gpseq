/* ConcatArrayBuffer.vala
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
	 * A concatenated array buffer.
	 */
	internal class ConcatArrayBuffer<G> : ArrayBuffer<G> {
		private ArrayBuffer<G> _left;
		private ArrayBuffer<G> _right;

		/**
		 * Creates a new concatenated array buffer.
		 * @param left the left input
		 * @param right the right input
		 */
		public ConcatArrayBuffer (ArrayBuffer<G> left, ArrayBuffer<G> right) {
			base({});
			_left = left;
			_right = right;
		}

		public override int size {
			get {
				return _left.size + _right.size;
			}
		}

		public override bool foreach (ForallFunc<G> f) {
			if (!_left.foreach(f)) return false;
			if (!_right.foreach(f)) return false;
			return true;
		}

		public new override unowned G get (int index) {
			assert(index < size);
			if (index < _left.size) {
				return _left[index];
			} else {
				return _right[index - _left.size];
			}
		}

		public override G get_owned (int index) {
			assert(index < size);
			if (index < _left.size) {
				return _left.get_owned(index);
			} else {
				return _right.get_owned(index - _left.size);
			}
		}

		public new override void set (int index, owned G item) {
			assert(index < size);
			if (index < _left.size) {
				_left[index] = item;
			} else {
				_right[index - _left.size] = item;
			}
		}

		public override ArrayBuffer<G> slice (int start, int stop) {
			if (start == 0 && stop == size) return this;
			int size_l = _left.size;
			if (start >= size_l) {
				return _right.slice(start - size_l, stop - size_l);
			} else if (stop <= size_l) {
				return _left.slice(start, stop);
			} else {
				ArrayBuffer<G> left = _left.slice(start, size_l);
				ArrayBuffer<G> right = _right.slice(0, stop - size_l);
				return new ConcatArrayBuffer<G>(left, right);
			}
		}
	}
}
