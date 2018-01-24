/* benchmark-chop.vala
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

private const int SKIP_LENGTH = LENGTH / 8;
private const int LIMIT_LENGTH = LENGTH / 4;

void benchmark_chop (Reporter r) {
	r.group("chop", (r) => {
		r.report("chop:sequential", (s) => {
			create_infinite_int_seq()
				.chop(SKIP_LENGTH, LIMIT_LENGTH)
				.foreach((g) => {});
		});

		r.report("chop:parallel", (s) => {
			create_infinite_int_seq()
				.parallel()
				.chop(SKIP_LENGTH, LIMIT_LENGTH)
				.foreach((g) => {});
		});

		r.report("chop_ordered:parallel", (s) => {
			create_infinite_int_seq()
				.parallel()
				.chop_ordered(SKIP_LENGTH, LIMIT_LENGTH)
				.foreach((g) => {});
		});
	});
}
