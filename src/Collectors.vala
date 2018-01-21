/* Collectors.vala
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

namespace Gpseq {
	/**
	 * Various collector implementations.
	 */
	namespace Collectors {
		/**
		 * Returns a collector that accumulates the elements into a new generic
		 * array.
		 *
		 * @return the collector implementation
		 */
		public Collector<G,void*,GenericArray<G>> to_generic_array<G> () {
			return new GenericArrayCollector<G>();
		}

		/**
		 * Returns a collector that accumulates the elements into a new list.
		 *
		 * There are no guarantees on the type, mutability, or thread-safety of
		 * the list.
		 *
		 * @return the collector implementation
		 */
		public Collector<G,void*,Gee.List<G>> to_list<G> () {
			return new ListCollector<G>();
		}

		/**
		 * Returns a collector that accumulates the elements into a new
		 * concurrent list. the list is thread-safe.
		 *
		 * There are no guarantees on the type or mutability of the list.
		 *
		 * @return the collector implementation
		 */
		public Collector<G,void*,Gee.List<G>> to_concurrent_list<G> () {
			return new ConcurrentListCollector<G>();
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,int> sum_int<G> (owned MapFunc<int,G> mapper) {
			return new SumIntCollector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,uint> sum_uint<G> (owned MapFunc<uint,G> mapper) {
			return new SumUintCollector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,long> sum_long<G> (owned MapFunc<long,G> mapper) {
			return new SumLongCollector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,ulong> sum_ulong<G> (owned MapFunc<ulong,G> mapper) {
			return new SumUlongCollector<G>((owned) mapper);
		}

		// TODO public Collector<G,void*,float?> sum_float<G> (owned MapFunc<float?,G> mapper) {}

		// TODO public Collector<G,void*,double?> sum_double<G> (owned MapFunc<double?,G> mapper) {}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,int32> sum_int32<G> (owned MapFunc<int32,G> mapper) {
			return new SumInt32Collector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,uint32> sum_uint32<G> (owned MapFunc<uint32,G> mapper) {
			return new SumUint32Collector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,int64?> sum_int64<G> (owned MapFunc<int64?,G> mapper) {
			return new SumInt64Collector<G>((owned) mapper);
		}

		/**
		 * Returns a collector that produces the sum of the given function
		 * applied to the elements. If no elements, the result is 0.
		 *
		 * The //mapper// function must not return null.
		 *
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 * @return the collector implementation
		 */
		public Collector<G,void*,uint64?> sum_uint64<G> (owned MapFunc<uint64?,G> mapper) {
			return new SumUint64Collector<G>((owned) mapper);
		}
	}
}
