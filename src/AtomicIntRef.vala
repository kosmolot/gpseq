/* AtomicIntRef.vala
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

namespace Gpseq {
	/**
	 * A int value that guarantees atomic update
	 */
	internal class AtomicIntRef : Object {
		private int _val;

		public AtomicIntRef (int val = 0) {
			_val = val;
		}

		public int val {
			get {
				return AtomicInt.get(ref _val);
			}
			set {
				AtomicInt.set(ref _val, value);
			}
		}

		public int add (int val) {
			return AtomicInt.add(ref _val, val);
		}

		public bool compare_and_exchange (int oldval, int newval) {
			return AtomicInt.compare_and_exchange(ref _val, oldval, newval);
		}

		public void inc () {
			AtomicInt.inc(ref _val);
		}

		public bool dec_and_test () {
			return AtomicInt.dec_and_test(ref _val);
		}
	}
}
