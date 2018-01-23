/* utils.vala
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

public GenericArray<int> create_rand_generic_int_array (int len) {
	var array = new GenericArray<int>(len);
	for (int i = 0; i < len; i++) {
		array.add((int) Random.next_int());
	}
	return array;
}

public Gpseq.Seq<int> create_rand_int_seq () {
	return Gpseq.Seq.of_supply_func<int>(() => (int)Random.next_int());
}

public G random_pick<G> (G[] array, out int? index = null) {
	assert(array.length > 0);
	int32 len = array.length;
	if (len < 0) len = int32.MAX;
	int pick = (int) Random.int_range(0, len);
	index = pick;
	return array[pick];
}
