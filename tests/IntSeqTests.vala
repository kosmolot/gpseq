/* IntSeqTests.vala
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

using Gpseq;
using Gee;

public class IntSeqTests : SeqTests<int> {
	private Rand _rand;

	public IntSeqTests () {
		base("seq<int>");
		_rand = new Rand();
	}

	protected override Seq<int> create_rand_seq () {
		return Seq.of_supply_func<int>((SupplyFunc<int>) random);
	}

	protected override GenericArray<int> create_rand_generic_array (int length) {
		GenericArray<int> array = new GenericArray<int>(length);
		for (int i = 0; i < length; i++) {
			array.add( random() );
		}
		return array;
	}

	protected override GenericArray<int> create_distinct_generic_array (int length) {
		GenericArray<int> array = new GenericArray<int>(length);
		for (int i = 0; i < length; i++) {
			array.add(i);
		}
		return array;
	}

	protected override uint hash (int g) {
		return direct_hash((void*) g);
	}

	protected override bool equal (int a, int b) {
		return a == b;
	}

	protected override int compare (int a, int b) {
		return a < b ? -1 : (a == b ? 0 : 1);
	}

	protected override bool filter (int g) {
		return g % 2 == 0;
	}

	protected override int random () {
		lock (_rand) {
			return (int) _rand.next_int();
		}
	}

	protected override int combine (owned int a, owned int b) {
		return a + b;
	}

	protected override int identity () {
		return 0;
	}

	protected override string map_to_str (owned int g) {
		return g.to_string();
	}

	protected override Iterator<int> flat_map (owned int g) {
		lock (_rand) {
			_rand.set_seed(g);
			Gee.List<int> list = new ArrayList<int>();
			list.add(g);
			list.add((int) _rand.next_int());
			list.add((int) _rand.next_int());
			return list.iterator();
		}
	}

	protected override int map_to_int (owned int g) {
		return g;
	}
}
