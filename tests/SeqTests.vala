/* SeqTests.vala
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
using TestUtils;

public abstract class SeqTests<G> : Gpseq.TestSuite {
	private const int LENGTH = 65536;
	private const int SKIP = 16384;
	private const int LIMIT = 32768;
	private const int OVERSIZE = LENGTH + 726;

	public SeqTests (string name) {
		base(name);
		register_tests();
	}

	private void register_tests () {
		add_test("iterator", test_iterator);
		add_test("spliterator", test_spliterator);

		add_test("count", test_count);
		add_test("count:filtered", () => test_filtered_count(false));
		add_test("count:filtered:parallel", () => test_filtered_count(true));

		add_test("distinct", () => test_distinct(false));
		add_test("distinct:parallel", () => test_distinct(true));

		add_test("all_match", () => test_all_match(false));
		add_test("all_match:parallel", () => test_all_match(true));
		add_test("any_match", () => test_any_match(false));
		add_test("any_match:parallel", () => test_any_match(true));
		add_test("none_match", () => test_none_match(false));
		add_test("none_match:parallel", () => test_none_match(true));

		add_test("find_any", () => test_find_any(false));
		add_test("find_any:parallel", () => test_find_any(true));
		add_test("find_first", () => test_find_first(false));
		add_test("find_first:parallel", () => test_find_first(true));

		add_test("skip", () => test_skip(false, SKIP));
		add_test("skip:parallel", () => test_skip(true, SKIP));
		add_test("skip:zero", () => test_skip(false, 0));
		add_test("skip:zero:parallel", () => test_skip(true, 0));
		add_test("skip:oversize", () => test_skip(false, OVERSIZE));
		add_test("skip:oversize:parallel", () => test_skip(true, OVERSIZE));
		add_test("limit", () => test_limit(false, LIMIT));
		add_test("limit:parallel", () => test_limit(true, LIMIT));
		add_test("limit:oversize", () => test_limit(false, OVERSIZE));
		add_test("limit:oversize:parallel", () => test_limit(true, OVERSIZE));
		add_test("limit:short-circuit-infinite", () => test_limit_short_circuiting(false));
		add_test("limit:short-circuit-infinite:parallel", () => test_limit_short_circuiting(true));
		add_test("chop", () => test_chop(false, SKIP, LIMIT));
		add_test("chop:parallel", () => test_chop(true, SKIP, LIMIT));
		add_test("chop:zero-skip", () => test_chop(false, 0, LIMIT));
		add_test("chop:zero-skip:parallel", () => test_chop(true, 0, LIMIT));
		add_test("chop:oversize-skip", () => test_chop(false, OVERSIZE, LIMIT));
		add_test("chop:oversize-skip:parallel", () => test_chop(true, OVERSIZE, LIMIT));
		add_test("chop:zero-limit", () => test_chop(false, SKIP, 0));
		add_test("chop:zero-limit:parallel", () => test_chop(true, SKIP, 0));
		add_test("chop:oversize-limit", () => test_chop(false, SKIP, OVERSIZE));
		add_test("chop:oversize-limit:parallel", () => test_chop(true, SKIP, OVERSIZE));
		add_test("chop:unlimited", () => test_chop(false, SKIP, -1));
		add_test("chop:unlimited:parallel", () => test_chop(true, SKIP, -1));
		add_test("chop:zero-skip:zero-limit", () => test_chop(false, 0, 0));
		add_test("chop:zero-skip:zero-limit:parallel", () => test_chop(true, 0, 0));
		add_test("chop:zero-skip:oversize-limit", () => test_chop(false, 0, OVERSIZE));
		add_test("chop:zero-skip:oversize-limit:parallel", () => test_chop(true, 0, OVERSIZE));
		add_test("chop:zero-skip:unlimited", () => test_chop(false, 0, -1));
		add_test("chop:zero-skip:unlimited:parallel", () => test_chop(true, 0, -1));
		add_test("chop:oversize-skip:zero-limit", () => test_chop(false, OVERSIZE, 0));
		add_test("chop:oversize-skip:zero-limit:parallel", () => test_chop(true, OVERSIZE, 0));
		add_test("chop:oversize-skip:oversize-limit", () => test_chop(false, OVERSIZE, OVERSIZE));
		add_test("chop:oversize-skip:oversize-limit:parallel", () => test_chop(true, OVERSIZE, OVERSIZE));
		add_test("chop:oversize-skip:unlimited", () => test_chop(false, OVERSIZE, -1));
		add_test("chop:oversize-skip:unlimited:parallel", () => test_chop(true, OVERSIZE, -1));
		add_test("chop:short-circuit-infinite", () => test_chop_short_circuiting(false));
		add_test("chop:short-circuit-infinite:parallel", () => test_chop_short_circuiting(true));

		add_test("skip_ordered", () => test_skip_ordered(false, SKIP));
		add_test("skip_ordered:parallel", () => test_skip_ordered(true, SKIP));
		add_test("skip_ordered:zero", () => test_skip_ordered(false, 0));
		add_test("skip_ordered:zero:parallel", () => test_skip_ordered(true, 0));
		add_test("skip_ordered:oversize", () => test_skip_ordered(false, OVERSIZE));
		add_test("skip_ordered:oversize:parallel", () => test_skip_ordered(true, OVERSIZE));
		add_test("limit_ordered", () => test_limit_ordered(false, LIMIT));
		add_test("limit_ordered:parallel", () => test_limit_ordered(true, LIMIT));
		add_test("limit_ordered:oversize", () => test_limit_ordered(false, OVERSIZE));
		add_test("limit_ordered:oversize:parallel", () => test_limit_ordered(true, OVERSIZE));
		add_test("limit_ordered:short-circuit-infinite", () => test_limit_ordered_short_circuiting(false));
		add_test("limit_ordered:short-circuit-infinite:parallel", () => test_limit_ordered_short_circuiting(true));
		add_test("chop_ordered", () => test_chop_ordered(false, SKIP, LIMIT));
		add_test("chop_ordered:parallel", () => test_chop_ordered(true, SKIP, LIMIT));
		add_test("chop_ordered:zero-skip", () => test_chop_ordered(false, 0, LIMIT));
		add_test("chop_ordered:zero-skip:parallel", () => test_chop_ordered(true, 0, LIMIT));
		add_test("chop_ordered:oversize-skip", () => test_chop_ordered(false, OVERSIZE, LIMIT));
		add_test("chop_ordered:oversize-skip:parallel", () => test_chop_ordered(true, OVERSIZE, LIMIT));
		add_test("chop_ordered:zero-limit", () => test_chop_ordered(false, SKIP, 0));
		add_test("chop_ordered:zero-limit:parallel", () => test_chop_ordered(true, SKIP, 0));
		add_test("chop_ordered:oversize-limit", () => test_chop_ordered(false, SKIP, OVERSIZE));
		add_test("chop_ordered:oversize-limit:parallel", () => test_chop_ordered(true, SKIP, OVERSIZE));
		add_test("chop_ordered:unlimited", () => test_chop_ordered(false, SKIP, -1));
		add_test("chop_ordered:unlimited:parallel", () => test_chop_ordered(true, SKIP, -1));
		add_test("chop_ordered:zero-skip:zero-limit", () => test_chop_ordered(false, 0, 0));
		add_test("chop_ordered:zero-skip:zero-limit:parallel", () => test_chop_ordered(true, 0, 0));
		add_test("chop_ordered:zero-skip:oversize-limit", () => test_chop_ordered(false, 0, OVERSIZE));
		add_test("chop_ordered:zero-skip:oversize-limit:parallel", () => test_chop_ordered(true, 0, OVERSIZE));
		add_test("chop_ordered:zero-skip:unlimited", () => test_chop_ordered(false, 0, -1));
		add_test("chop_ordered:zero-skip:unlimited:parallel", () => test_chop_ordered(true, 0, -1));
		add_test("chop_ordered:oversize-skip:zero-limit", () => test_chop_ordered(false, OVERSIZE, 0));
		add_test("chop_ordered:oversize-skip:zero-limit:parallel", () => test_chop_ordered(true, OVERSIZE, 0));
		add_test("chop_ordered:oversize-skip:oversize-limit", () => test_chop_ordered(false, OVERSIZE, OVERSIZE));
		add_test("chop_ordered:oversize-skip:oversize-limit:parallel", () => test_chop_ordered(true, OVERSIZE, OVERSIZE));
		add_test("chop_ordered:oversize-skip:unlimited", () => test_chop_ordered(false, OVERSIZE, -1));
		add_test("chop_ordered:oversize-skip:unlimited:parallel", () => test_chop_ordered(true, OVERSIZE, -1));
		add_test("chop_ordered:short-circuit-infinite", () => test_chop_ordered_short_circuiting(false));
		add_test("chop_ordered:short-circuit-infinite:parallel", () => test_chop_ordered_short_circuiting(true));

		add_test("filter", test_filter);

		add_test("fold", () => test_fold(false));
		add_test("fold:parallel", () => test_fold(true));
		add_test("reduce", () => test_reduce(false));
		add_test("reduce:parallel", () => test_reduce(true));

		add_test("map", test_map);
		add_test("flat_map", test_flat_map);

		add_test("max", () => test_max(false));
		add_test("max:parallel", () => test_max(true));
		add_test("min", () => test_min(false));
		add_test("min:parallel", () => test_min(true));

		add_test("order_by", () => test_order_by(false));
		add_test("order_by:parallel", () => test_order_by(true));
		add_test("order_by:check-stable", () => test_stable_order_by(false));
		add_test("order_by:check-stable:parallel", () => test_stable_order_by(true));

		add_test("foreach", () => test_foreach(false));
		add_test("foreach:parallel", () => test_foreach(true));

		add_test("collect", () => test_collect(false));
		add_test("collect:parallel", () => test_collect(true));
		add_test("collect_ordered", () => test_collect_ordered(false));
		add_test("collect_ordered:parallel", () => test_collect_ordered(true));

		add_test("collectors-to_generic_array", () => test_collectors_to_generic_array(false));
		add_test("collectors-to_generic_array:parallel", () => test_collectors_to_generic_array(true));
		add_test("collectors-to_generic_array:ordered", () => test_collectors_to_generic_array(false, true));
		add_test("collectors-to_generic_array:ordered:parallel", () => test_collectors_to_generic_array(true, true));
		add_test("collectors-to_list", () => test_collectors_to_list(false));
		add_test("collectors-to_list:parallel", () => test_collectors_to_list(true));
		add_test("collectors-to_list:ordered", () => test_collectors_to_list(false, true));
		add_test("collectors-to_list:ordered:parallel", () => test_collectors_to_list(true, true));
		add_test("collectors-to_concurrent_list", () => test_collectors_to_concurrent_list(false));
		add_test("collectors-to_concurrent_list:parallel", () => test_collectors_to_concurrent_list(true));
		add_test("collectors-to_concurrent_list:ordered", () => test_collectors_to_concurrent_list(false, true));
		add_test("collectors-to_concurrent_list:ordered:parallel", () => test_collectors_to_concurrent_list(true, true));

		add_test("collectors-sum_int", () => test_collectors_sum_int(false));
		add_test("collectors-sum_int:parallel", () => test_collectors_sum_int(true));
		add_test("collectors-sum_uint", () => test_collectors_sum_uint(false));
		add_test("collectors-sum_uint:parallel", () => test_collectors_sum_uint(true));
		add_test("collectors-sum_long", () => test_collectors_sum_long(false));
		add_test("collectors-sum_long:parallel", () => test_collectors_sum_long(true));
		add_test("collectors-sum_ulong", () => test_collectors_sum_ulong(false));
		add_test("collectors-sum_ulong:parallel", () => test_collectors_sum_ulong(true));
		// add_test("collectors-sum_float", () => test_collectors_sum_float(false));
		// add_test("collectors-sum_float:parallel", () => test_collectors_sum_float(true));
		// add_test("collectors-sum_double", () => test_collectors_sum_double(false));
		// add_test("collectors-sum_double:parallel", () => test_collectors_sum_double(true));
		add_test("collectors-sum_int32", () => test_collectors_sum_int32(false));
		add_test("collectors-sum_int32:parallel", () => test_collectors_sum_int32(true));
		add_test("collectors-sum_uint32", () => test_collectors_sum_uint32(false));
		add_test("collectors-sum_uint32:parallel", () => test_collectors_sum_uint32(true));
		add_test("collectors-sum_int64", () => test_collectors_sum_int64(false));
		add_test("collectors-sum_int64:parallel", () => test_collectors_sum_int64(true));
		add_test("collectors-sum_uint64", () => test_collectors_sum_uint64(false));
		add_test("collectors-sum_uint64:parallel", () => test_collectors_sum_uint64(true));

		add_test("complex-fold", () => test_complex_fold(false));
		add_test("complex-fold:parallel", () => test_complex_fold(true));
	}

	/**
	 * Creates an sequential infinite unordered seq of random elements.
	 * @return the created seq
	 */
	protected abstract Seq<G> create_rand_seq ();

	/**
	 * Creates a generic array of random elements.
	 * @return the created array
	 */
	protected abstract GenericArray<G> create_rand_generic_array (int length);

	/**
	 * Creates a generic array of distinct elements.
	 * @return the created array
	 */
	protected abstract GenericArray<G> create_distinct_generic_array (int length);

	protected abstract uint hash (G g);
	protected abstract bool equal (G a, G b);
	protected abstract int compare (G a, G b);
	protected abstract bool filter (G g);
	protected abstract G random ();
	protected abstract G combine (owned G a, owned G b);
	protected abstract G identity ();
	protected abstract string map_to_str (owned G g);
	protected abstract Iterator<G> flat_map (owned G g);
	protected abstract int map_to_int (owned G g);

	private void test_iterator () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Iterator<G> iter = Seq.of_generic_array<G>(array).iterator();
		assert_equal_array_and_iter(array.data, iter, equal);
	}

	private void test_spliterator () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Spliterator<G> spliter = Seq.of_generic_array<G>(array).spliterator();
		assert(spliter.is_size_known);
		assert(spliter.estimated_size == array.length);
		G? item = null;
		int idx = 0;
		while (spliter.try_advance((g) => item = g)) {
			assert( equal(item, array[idx++]) );
		}
	}

	private void test_count () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		int result = Seq.of_generic_array<G>(array).count();
		assert(result == LENGTH);
	}

	private void test_filtered_count (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq.filter(filter).count();

		int validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			if (filter(array[i])) validation++;
		}
		assert(result == validation);
	}

	private void test_distinct (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Iterator<G> result = seq.distinct(hash, equal).iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		GenericArray<G> validation = new GenericArray<G>(result_array.length);
		Set<G> seen = new HashSet<G>(hash, equal);
		for (int i = 0; i < array.length; i++) {
			if (!seen.contains(array[i])) {
				seen.add(array[i]);
				validation.add(array[i]);
			}
		}

		if (parallel) {
			result_array.sort_with_data(compare);
			validation.sort_with_data(compare);
		}
		assert_equal_array<G>(result_array.data, validation.data, equal);
	}

	private void test_all_match (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);

		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( seq.all_match((g) => true) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( !seq.all_match((g) => false) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int i = 0;
		assert( !seq.all_match((g) => AtomicInt.compare_and_exchange(ref i, 0, 1)) );

		// empty
		seq = Seq.empty<G>();
		if (parallel) seq = seq.parallel();
		assert( seq.all_match((g) => false) );

		// short-circuiting
		seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		assert( !seq.all_match((g) => false) );
	}

	private void test_any_match (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);

		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( seq.any_match((g) => true) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( !seq.any_match((g) => false) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G pick = random_pick<G>(array.data);
		assert( seq.any_match((g) => equal(g, pick)) );

		// empty
		seq = Seq.empty<G>();
		if (parallel) seq = seq.parallel();
		assert( !seq.any_match((g) => true) );

		// short-circuiting
		seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		assert( seq.any_match((g) => true) );
	}

	private void test_none_match (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);

		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( !seq.none_match((g) => true) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( seq.none_match((g) => false) );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G pick = random_pick<G>(array.data);
		assert( !seq.none_match((g) => equal(g, pick)) );

		// empty
		seq = Seq.empty<G>();
		if (parallel) seq = seq.parallel();
		assert( seq.none_match((g) => true) );

		// short-circuiting
		seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		assert( !seq.none_match((g) => true) );
	}

	private void test_find_any (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);

		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( seq.find_any((g) => true).is_present );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( !seq.find_any((g) => false).is_present );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G pick = random_pick<G>(array.data);
		assert( equal(seq.find_any((g) => equal(g, pick)).value, pick) );

		// empty
		seq = Seq.empty<G>();
		if (parallel) seq = seq.parallel();
		assert( !seq.find_any((g) => true).is_present );

		// short-circuiting
		seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		assert( seq.find_any((g) => true).is_present );
	}

	private void test_find_first (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);

		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();

		assert( seq.find_first((g) => true).is_present );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		assert( !seq.find_first((g) => false).is_present );

		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G pick = random_pick<G>(array.data);
		assert( equal(seq.find_first((g) => equal(g, pick)).value, pick) );

		// empty
		seq = Seq.empty<G>();
		if (parallel) seq = seq.parallel();
		assert( !seq.find_first((g) => true).is_present );

		// short-circuiting
		seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		assert( seq.find_first((g) => true).is_present );

		// encounter order
		array = create_distinct_generic_array(LENGTH);
		int idx0 = 0;
		int idx1 = 0;
		G? pick0 = null;
		G? pick1 = null;
		G? first = null;
		while (idx0 == idx1) {
			pick0 = random_pick<G>(array.data, out idx0);
			pick1 = random_pick<G>(array.data, out idx1);
			first = idx0 <= idx1 ? pick0 : pick1;
		}
		seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Optional<G> result = seq.find_first((g) => {
			return equal(g, pick0) || equal(g, pick1);
		});
		assert( equal(result.value, first) );
	}

	private void test_skip (bool parallel, int skip) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq.skip(skip).count();
		int validation = skip < array.length ? array.length - skip : 0;
		assert(result == validation);
	}

	private void test_limit (bool parallel, int limit) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq.limit(limit).count();
		int validation = limit > array.length ? array.length : limit;
		assert(result == validation);
	}

	private void test_limit_short_circuiting (bool parallel) {
		Seq<G> seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		int result = seq.limit(LIMIT).count();
		assert(result == LIMIT);
	}

	private void test_chop (bool parallel, int skip, int limit) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq.chop(skip, limit).count();
		int s = skip > array.length ? array.length : skip;
		int validation = limit < 0 ? array.length - s : int.min(limit, array.length - s);
		assert(result == validation);
	}

	private void test_chop_short_circuiting (bool parallel) {
		Seq<G> seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		int result = seq.chop(SKIP, LIMIT).count();
		assert(result == LIMIT);
	}

	private void test_skip_ordered (bool parallel, int skip) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Iterator<G> result = seq.skip_ordered(skip).iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		int s = skip > array.length ? array.length : skip;
		assert_equal_array<G>(array.data[s:array.length], result_array.data, equal);
	}

	private void test_limit_ordered (bool parallel, int limit) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Iterator<G> result = seq.limit_ordered(limit).iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		int l = limit > array.length ? array.length : limit;
		assert_equal_array<G>(array.data[0:l], result_array.data, equal);
	}

	private void test_limit_ordered_short_circuiting (bool parallel) {
		Seq<G> seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		int result = seq.limit_ordered(LIMIT).count();
		assert(result == LIMIT);
	}

	private void test_chop_ordered (bool parallel, int skip, int limit) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Iterator<G> result = seq.chop_ordered(skip, limit).iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		int s = skip > array.length ? array.length : skip;
		int l = (s + limit > array.length || limit < 0) ? array.length : s + limit;
		assert_equal_array<G>(array.data[s:l], result_array.data, equal);
	}

	private void test_chop_ordered_short_circuiting (bool parallel) {
		Seq<G> seq = create_rand_seq();
		if (parallel) seq = seq.parallel();
		int result = seq.chop_ordered(SKIP, LIMIT).count();
		assert(result == LIMIT);
	}

	private void test_filter () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Iterator<G> result = Seq.of_generic_array<G>(array)
				.filter(filter)
				.iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		GenericArray<G> validation = new GenericArray<G>();
		for (int i = 0; i < LENGTH; i++) {
			if (filter(array[i])) validation.add(array[i]);
		}
		assert_equal_array<G>(validation.data, result_array.data, equal);
	}

	private void test_fold (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G result = seq.fold(combine, combine, identity());

		G validation = identity();
		for (int i = 0; i < array.length; i++) {
			validation = combine(array[i], validation);
		}
		assert( equal(result, validation) );
	}

	private void test_reduce (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		G result = seq.reduce(combine).value;

		G? validation = null;
		bool found = false;
		for (int i = 0; i < array.length; i++) {
			if (!found) {
				validation = array[i];
				found = true;
			} else {
				validation = combine(array[i], validation);
			}
		}
		assert(found);
		assert( equal(result, validation) );
	}

	private void test_map () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Iterator<string> result = Seq.of_generic_array<G>(array)
				.map<string>(map_to_str)
				.iterator();
		GenericArray<string> result_array = iter_to_generic_array<string>(result);

		GenericArray<string> validation = new GenericArray<string>();
		for (int i = 0; i < LENGTH; i++) {
			validation.add( map_to_str(array[i]) );
		}
		assert_equal_array<string>(validation.data, result_array.data, (a, b) => str_equal(a, b));
	}

	private void test_flat_map () {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Iterator<G> result = Seq.of_generic_array<G>(array)
				.flat_map<G>(flat_map)
				.iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		GenericArray<G> validation = new GenericArray<G>();
		for (int i = 0; i < LENGTH; i++) {
			Iterator<G> iter = flat_map(array[i]);
			iter.foreach((g) => {
				validation.add(g);
				return true;
			});
		}
		assert_equal_array<G>(validation.data, result_array.data, equal);
	}

	private void test_max (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Optional<G> result = seq.max(compare);

		G? validation = null;
		bool found = false;
		for (int i = 0; i < array.length; i++) {
			if (!found) {
				validation = array[i];
				found = true;
			} else {
				if (compare(array[i], validation) >= 0) validation = array[i];
			}
		}
		assert(found);
		assert( equal(result.value, validation) );
	}

	private void test_min (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Optional<G> result = seq.min(compare);

		G? validation = null;
		bool found = false;
		for (int i = 0; i < array.length; i++) {
			if (!found) {
				validation = array[i];
				found = true;
			} else {
				if (compare(array[i], validation) <= 0) validation = array[i];
			}
		}
		assert(found);
		assert( equal(result.value, validation) );
	}

	private void test_order_by (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		Iterator<G> result = seq.order_by(compare).iterator();
		GenericArray<G> result_array = iter_to_generic_array<G>(result);

		assert_sorted<G>(result_array.data, compare);
		array.sort_with_data(compare);
		assert_equal_array<G>(array.data, result_array.data, equal);
	}

	private void test_stable_order_by (bool parallel) {
		var array = new GenericArray<ValueContainer<G>>(LENGTH);
		for (int i = 0; i < LENGTH; i++) {
			array.add( new ValueContainer<G>(random()) );
		}
		var seq = Seq.of_generic_array<ValueContainer<G>>(array);
		if (parallel) seq = seq.parallel();
		var result = seq.order_by((a, b) => compare(a.value, b.value)).iterator();
		var result_array = iter_to_generic_array<ValueContainer<G>>(result);
		// g_ptr_array_sort_with_data is guaranteed to be a stable sort since glib 2.32
		array.sort_with_data((a, b) => compare(a.value, b.value));
		assert_equal_array<ValueContainer<G>>(array.data, result_array.data, (a, b) => a == b);
	}

	private void test_foreach (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = 0;
		seq.foreach( (g) => AtomicInt.add(ref result, map_to_int(g)) );
		int validation = 0;
		for (int i = 0; i < array.length; i++) {
			validation += map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collect (bool parallel) {
		test_collectors_to_generic_array(parallel);
		test_collectors_to_list(parallel);
		test_collectors_to_concurrent_list(parallel);
	}

	private void test_collect_ordered (bool parallel) {
		test_collectors_to_generic_array(parallel, true);
		test_collectors_to_list(parallel, true);
		test_collectors_to_concurrent_list(parallel, true);
	}

	private void test_collectors_to_generic_array (bool parallel, bool ordered = false) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		var collector = Collectors.to_generic_array<G>();
		GenericArray<G> result_array;
		if (ordered) {
			result_array = seq.collect_ordered(collector);
		} else {
			result_array = seq.collect(collector);
		}
		assert_equal_array<G>(array.data, result_array.data, equal);
	}

	private void test_collectors_to_list (bool parallel, bool ordered = false) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		var collector = Collectors.to_list<G>();
		Gee.List<G> list;
		if (ordered) {
			list = seq.collect_ordered(collector);
		} else {
			list = seq.collect(collector);
		}
		assert_equal_array_and_iter(array.data, list.iterator(), equal);
	}

	private void test_collectors_to_concurrent_list (bool parallel, bool ordered = false) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		var collector = Collectors.to_concurrent_list<G>();
		Gee.List<G> list;
		if (ordered) {
			list = seq.collect_ordered(collector);
		} else {
			list = seq.collect(collector);
		}
		if (!parallel || ordered) {
			assert_equal_array_and_iter(array.data, list.iterator(), equal);
		}
	}

	private void test_complex_fold (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq
			.filter(filter)
			.distinct(hash, equal)
			.order_by(compare)
			.chop_ordered(SKIP, LIMIT)
			.map<int>(map_to_int)
			.fold<int>((g, a) => g + a, (a, b) => a + b, 0);
		int validation = get_complex_fold_validation(array);
		assert(result == validation);
	}

	private int get_complex_fold_validation (GenericArray<G> array) {
		GenericArray<G> filtered = new GenericArray<G>();
		for (int i = 0; i < array.length; i++) {
			if ( filter(array[i]) ) filtered.add(array[i]);
		}

		GenericArray<G> distinct = new GenericArray<G>();
		Set<G> seen = new HashSet<G>(hash, equal);
		for (int i = 0; i < filtered.length; i++) {
			if (!seen.contains(filtered[i])) {
				seen.add(filtered[i]);
				distinct.add(filtered[i]);
			}
		}
		distinct.sort_with_data(compare);

		int sum = 0;
		int limit = int.min(distinct.length, SKIP + LIMIT);
		for (int i = SKIP; i < limit; i++) {
			sum += map_to_int(distinct[i]);
		}
		return sum;
	}

	private void test_collectors_sum_int (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int result = seq.collect( Collectors.sum_int<G>(map_to_int) );
		int validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_uint (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		uint result = seq.collect( Collectors.sum_uint<G>((g) => (uint)map_to_int(g)) );
		uint validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (uint) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_long (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		long result = seq.collect( Collectors.sum_long<G>((g) => (long)map_to_int(g)) );
		long validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (long) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_ulong (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		ulong result = seq.collect( Collectors.sum_ulong<G>((g) => (ulong)map_to_int(g)) );
		ulong validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (ulong) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	// private void test_collectors_sum_float (bool parallel) {}

	// private void test_collectors_sum_double (bool parallel) {}

	private void test_collectors_sum_int32 (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int32 result = seq.collect( Collectors.sum_int32<G>((g) => (int32)map_to_int(g)) );
		int32 validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (int32) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_uint32 (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		uint32 result = seq.collect( Collectors.sum_uint32<G>((g) => (uint32)map_to_int(g)) );
		uint32 validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (uint32) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_int64 (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		int64 result = seq.collect( Collectors.sum_int64<G>((g) => (int64)map_to_int(g)) );
		int64 validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (int64) map_to_int(array[i]);
		}
		assert(result == validation);
	}

	private void test_collectors_sum_uint64 (bool parallel) {
		GenericArray<G> array = create_rand_generic_array(LENGTH);
		Seq<G> seq = Seq.of_generic_array<G>(array);
		if (parallel) seq = seq.parallel();
		uint64 result = seq.collect( Collectors.sum_uint64<G>((g) => (uint64)map_to_int(g)) );
		uint64 validation = 0;
		for (int i = 0; i < LENGTH; i++) {
			validation += (uint64) map_to_int(array[i]);
		}
		assert(result == validation);
	}
}
