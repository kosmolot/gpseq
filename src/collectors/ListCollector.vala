/* ListCollector.vala
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

private class Gpseq.Collectors.ListCollector<G> : Object, Collector<G,Gee.List<G>,Gee.List<G>> {
	public CollectorFeatures features {
		get {
			return 0;
		}
	}

	public Gee.List<G> create_accumulator () {
		return new ArrayList<G>();
	}

	public void accumulate (G g, Gee.List<G> a) {
		a.add(g);
	}

	public Gee.List<G> combine (Gee.List<G> a, Gee.List<G> b) {
		a.add_all(b);
		return a;
	}

	public Gee.List<G> finish (Gee.List<G> a) {
		return a;
	}
}
