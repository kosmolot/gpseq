/* Gpseq.vala
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
	 * Sorts the given array by comparing with the specified compare function,
	 * in parallel. The sort is stable.
	 *
	 * Note. With nullable primitive types, this method produces an undesirable
	 * result if the compare function is not specified. you should provide
	 * specified compare function to get a proper result.
	 *
	 * {{{
	 *     int?[] array = {5, 4, 3, 2, 1};
	 *     parallel_sort<int?>(array);
	 *     // => the result is undesirable, such as 5, 2, 1, 3, 4
	 *
	 *     int?[] array2 = {5, 4, 3, 2, 1};
	 *     parallel_sort<int?>(array2, (a, b) => {
	 *         if (a == b) return 0;
	 *         else if (a == null) return -1;
	 *         else if (b == null) return 1;
	 *         else return a < b ? -1 : (a == b ? 0 : 1);
	 *     });
	 *     // => the result is 1, 2, 3, 4, 5
	 * }}}
	 *
	 * @param array an array to be sorted. it must be a gpointer array
	 * @param compare compare function to compare elements. if it is not
	 * specified, the result of {@link Gee.Functions.get_compare_func_for} is
	 * used
	 */
	public void parallel_sort<G> (G[] array, owned CompareDataFunc<G>? compare = null) {
		int len = array.length;
		if (len <= 1) return;
		G[] temp_array = new G[len];

		SubArray<G> sub = new SubArray<G>(array);
		SubArray<G> temp = new SubArray<G>(temp_array);
		Comparator<G> cmp = new Comparator<G>((owned) compare);

		TaskEnv env = TaskEnv.get_default_task_env();
		Executor exe = env.executor;
		int num_threads = exe.parallels;
		int threshold = env.resolve_threshold(len, num_threads);
		int max_depth = env.resolve_max_depth(len, num_threads);

		SortTask<G> task = new SortTask<G>(sub, temp, cmp, threshold, max_depth, exe);
		task.fork();
		task.join_quietly();
	}
}
