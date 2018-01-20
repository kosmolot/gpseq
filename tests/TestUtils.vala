/* TestUtils.vala
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

namespace TestUtils {
	public void assert_sorted<G> (G[] array, owned CompareDataFunc<G>? compare = null) {
		if (compare == null) compare = Gee.Functions.get_compare_func_for(typeof(G));
		for (int i = 0; i < array.length - 1; i++) {
			assert( compare(array[i], array[i+1]) <= 0 );
		}
	}

	public void assert_all_elements<G> (G[] array, Predicate<G> pred) {
		for (int i = 0; i < array.length; i++) {
			assert( pred(array[i]) );
		}
	}

	public int compare_nullable_int (int? a, int? b) {
		if (a == b) return 0;
		else if (a == null) return -1;
		else if (b == null) return 1;
		else return a < b ? -1 : (a == b ? 0 : 1);
	}

	public GenericArray<G> iter_to_generic_array<G> (Iterator<G> iter) {
		GenericArray<G> array = new GenericArray<G>();
		iter.foreach((g) => {
			array.add(g);
			return true;
		});
		return array;
	}

	public void assert_equal_array<G> (G[] array, G[] array2, owned EqualDataFunc<G>? equal = null) {
		assert(array.length == array2.length);
		if (equal == null) equal = Gee.Functions.get_equal_func_for(typeof(G));
		for (int i = 0; i < array.length; i++) {
			assert( equal(array[i], array2[i]) );
		}
	}

	public G random_pick<G> (G[] array, out int? index = null) {
		assert(array.length > 0);
		int32 len = array.length;
		if (len < 0) len = int32.MAX;
		int pick = (int) Random.int_range(0, len);
		index = pick;
		return array[pick];
	}

	public void assert_equal_array_and_iter<G> (G[] array, Iterator<G> iter, owned EqualDataFunc<G>? equal = null) {
		if (equal == null) equal = Gee.Functions.get_equal_func_for(typeof(G));
		int len = array.length;
		int i = 0;
		iter.foreach((g) => {
			assert(i < len);
			assert( equal(array[i++], g) );
			return true;
		});
		assert(i == len);
	}

	public string random_str (int length) {
		StringBuilder buf = new StringBuilder.sized(length);
		for (int i = 0; i < length; i++) {
			buf.append_c( random_char(48, 126) );
		}
		return buf.str;
	}

	private char random_char (char from, char to) {
		return (char)Random.int_range(from, to + 1);
	}

	public class ValueContainer<T> : Object {
		private T _value;

		public ValueContainer (T value) {
			_value = value;
		}

		public T value {
			get {
				return _value;
			}
		}
	}
}
