/* benchmark-flat-map.vala
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

void benchmark_flat_map (Reporter r) {
	r.group("flat_map", (r) => {
		r.report("flat_map:sequential", (s) => {
			var array = create_rand_generic_int_array(LENGTH / 32);
			s.start();
			Seq.of_generic_array<int>(array)
				.flat_map<int>((g) => {
					var list = new ArrayList<int>();
					list.add(g);
					list.add(111);
					list.add(222);
					return list.iterator();
				}).foreach((g) => {});
		});

		r.report("flat_map:parallel", (s) => {
			var array = create_rand_generic_int_array(LENGTH / 32);
			s.start();
			Seq.of_generic_array<int>(array)
				.parallel()
				.flat_map<int>((g) => {
					var list = new ArrayList<int>();
					list.add(g);
					list.add(111);
					list.add(222);
					return list.iterator();
				}).foreach((g) => {});
		});
	});
}
