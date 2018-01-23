/* benchmark-find.vala
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

using Benchmarks;
using Gpseq;
using Gee;

void benchmark_find (Reporter r) {
	r.group("find", (r) => {
		r.report("find_any:sequential", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			int pick = random_pick<int>(array.data);
			s.start();
			Seq.of_generic_array<int>(array)
				.find_any((g) => g == pick);
		});

		r.report("find_any:parallel", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			int pick = random_pick<int>(array.data);
			s.start();
			Seq.of_generic_array<int>(array)
				.parallel()
				.find_any((g) => g == pick);
		});

		r.report("find_first:parallel", (s) => {
			var array = create_rand_generic_int_array(LENGTH);
			int pick = random_pick<int>(array.data);
			s.start();
			Seq.of_generic_array<int>(array)
				.parallel()
				.find_first((g) => g == pick);
		});
	});
}
