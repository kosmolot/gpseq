/* StringSeqTests.vala
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

public class StringSeqTests : SeqTests<string> {
	private const string MAGIC_STRING = "seven-two-six";

	public StringSeqTests () {
		base("seq<string>");
	}

	protected override Seq<string> create_rand_seq () {
		return Seq.of_supply_func<string>((SupplyFunc<string>) random);
	}

	protected override GenericArray<string> create_rand_generic_array (int length) {
		GenericArray<string> array = new GenericArray<string>(length);
		for (int i = 0; i < length; i++) {
			array.add( random() );
		}
		return array;
	}

	protected override GenericArray<string> create_distinct_generic_array (int length) {
		GenericArray<string> array = new GenericArray<string>(length);
		for (int i = 0; i < length; i++) {
			array.add(i.to_string());
		}
		return array;
	}

	protected override uint hash (string g) {
		return str_hash(g);
	}

	protected override bool equal (string a, string b) {
		return str_equal(a, b);
	}

	protected override int compare (string a, string b) {
		return strcmp(a, b);
	}

	protected override bool filter (string g) {
		return !g.contains("a");
	}

	protected override string random () {
		return TestUtils.random_str(32);
	}

	protected override string combine (owned string a, owned string b) {
		int i = a == MAGIC_STRING ? 0 : int.parse(a);
		int i2 = b == MAGIC_STRING ? 0 : int.parse(b);
		int sum = i + i2;
		return sum.to_string();
	}

	protected override string identity () {
		return MAGIC_STRING;
	}

	protected override string map_to_str (owned string g) {
		return g;
	}

	protected override Iterator<string> flat_map (owned string g) {
		Gee.List<string> list = new ArrayList<string>();
		list.add(g);
		list.add("hello");
		list.add("world");
		return list.iterator();
	}

	protected override int map_to_int (owned string g) {
		return (int)hash(g);
	}
}
