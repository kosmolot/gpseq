/* DefaultTaskEnv.vala
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
	 * Default task env implementation.
	 */
	internal class DefaultTaskEnv : TaskEnv {
		private const int MIN_THRESHOLD = 16384; // 1 << 14
		private const long THRESHOLD_UNKNOWN = 1048576; // 1 << 20

		private Executor _executor;
		private int _threshold_unknown;

		public DefaultTaskEnv () {
			_executor = new ForkJoinPool.with_defaults();
			_threshold_unknown = (int) long.min(THRESHOLD_UNKNOWN, int.MAX);
		}

		public override Executor executor {
			get {
				return _executor;
			}
		}

		public override int resolve_threshold (int elements, int threads) {
			if (threads == 1) return elements;
			if (elements < 0) return _threshold_unknown;
			int t = elements / (threads * 2);
			return int.max(t, MIN_THRESHOLD);
		}

		public override int resolve_max_depth (int elements, int threads) {
			if (threads == 1) return 0;
			int n = int.max(threads * 4, threads * 8);
			n = int.max(threads, n);
			int v = 1, i = 0;
			while (v < n) {
				v = v << 1;
				i++;
			}
			return i;
		}
	}
}
