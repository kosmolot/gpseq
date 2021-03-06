/* FlatMappedContainer.vala
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
	/*
	 * A container which contains the elements of the results of applying a
	 * mapper function to the elements of a input.
	 */
	internal class FlatMappedContainer<R,G> : Object, Spliterator<R>, Container<R,G> {
		private const int INITIAL_CHUNK_BUFFER_SIZE = 128;

		private Spliterator<G> _spliterator; // may be a Container
		private Container<G,void*>? _parent;
		private FlatMapFunc<R,G> _mapper;
		private Iterator<R>? _storage;

		/**
		 * Creates a new flat mapped container.
		 * @param spliterator a spliterator that may or may not be a container
		 * @param parent the parent of the new container
		 * @param mapper a //non-interfering// and //stateless// mapping
		 * function
		 */
		public FlatMappedContainer (Spliterator<G> spliterator, Container<G,void*>? parent, owned FlatMapFunc<R,G> mapper) {
			_spliterator = spliterator;
			_parent = parent;
			_mapper = (owned) mapper;
		}

		public Container<G,void*>? parent {
			get {
				return _parent;
			}
		}

		public virtual void start (Seq seq) {
			if (_parent != null) _parent.start(seq);
			_parent = null;
		}

		public Spliterator<R>? try_split () {
			Spliterator<G>? source = _spliterator.try_split();
			if (source == null) {
				return null;
			} else {
				return new FlatMappedContainer<R,G>(source, _parent, (g) => { return _mapper(g); });
			}
		}

		public bool try_advance (Func<R> consumer) {
			bool result = false;
			if (_storage == null) {
				result = _spliterator.try_advance((g) => {
					_storage = _mapper(g);
				});
			}
			if ( _storage != null && (_storage.valid || _storage.next()) ) {
				consumer(_storage.get());
				if (!_storage.next()) {
					_storage = null;
				}
				return true;
			}
			return result;
		}

		public int estimated_size {
			get {
				return _spliterator.estimated_size;
			}
		}

		public bool is_size_known {
			get {
				return false;
			}
		}

		public void each (Func<R> f) {
			if (_storage != null) {
				_storage.foreach((g) => {
					f(g);
					return true;
				});
				_storage = null;
			}
			_spliterator.each((g) => {
				Iterator<R> iter = _mapper(g);
				iter.foreach((g) => {
					f(g);
					return true;
				});
			});
		}

		public bool each_chunk (EachChunkFunc<R> f) {
			R[] array = new R[INITIAL_CHUNK_BUFFER_SIZE];
			if (_storage != null) {
				int i = 0;
				_storage.foreach((g) => {
					if (i >= array.length) array.resize( next_pot(i) );
					array[i++] = g;
					return true;
				});
				if ( i != 0 && !f(array[0:i]) ) {
					return false;
				}
				_storage = null;
			}
			return _spliterator.each_chunk((chunk) => {
				int idx = 0;
				for (int i = 0; i < chunk.length; i++) {
					Iterator<R> iter = _mapper(chunk[i]);
					iter.foreach((g) => {
						if (idx >= array.length) array.resize( next_pot(idx) );
						array[idx++] = g;
						return true;
					});
				}
				if (idx == 0) return true;
				return f(array[0:idx]);
			});
		}

		/**
		 * Finds next power of two, which is greater than and not equal to n.
		 * @return next power of two, which is greater than and not equal to n
		 */
		private inline int next_pot (int n) {
			int v = 1;
			while (v <= n) {
				v = v << 1;
			}
			return v;
		}
	}
}
