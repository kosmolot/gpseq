/* ArrayBuffer.vala
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
	 * A wrapper utility of an array.
	 */
	internal class ArrayBuffer<G> : Object, Traversable<G> {
		private G[] _data;

		/**
		 * Creates a new array buffer.
		 * @param data a gpointer array
		 */
		public ArrayBuffer (owned G[] data) {
			_data = (owned) data;
		}

		/**
		 * The number of elements.
		 */
		public virtual int size {
			get {
				return _data.length;
			}
		}

		public virtual bool foreach (ForallFunc<G> f) {
			for (int i = 0, n = _data.length; i < n; i++) {
				if(!f(_data[i])) {
					return false;
				}
			}
			return true;
		}

		public new virtual unowned G get (int index) {
			return _data[index];
		}

		public virtual G get_owned (int index) {
			return _data[index];
		}

		public new virtual void set (int index, owned G item) {
			_data[index] = item;
		}

		/**
		 * Returns a slice of this array buffer.
		 *
		 * This method may or may not slice this array buffer instead of
		 * creating a new array buffer.
		 *
		 * @param start zero-based index of the begin of the slice
		 * @param stop zero-based index after the end of the slice
		 * @return the result slice
		 */
		public virtual ArrayBuffer<G> slice (int start, int stop) {
			if (start == 0) {
				if (stop != size) _data.resize(stop);
				return this;
			} else {
				G[] copy = _data[start:stop];
				_data = copy;
				return this;
			}
		}
	}
}
