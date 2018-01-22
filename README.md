# gpseq

[![Build Status](https://travis-ci.org/kosmolot/gpseq.svg?branch=master)](https://travis-ci.org/kosmolot/gpseq)
[![codecov](https://codecov.io/gh/kosmolot/gpseq/branch/master/graph/badge.svg)](https://codecov.io/gh/kosmolot/gpseq)

Gpseq is a GObject utility library providing parallel data processing.

```vala
using Gpseq;

string[] array = {"dog", "cat", "pig", "boar", "bear"};
Seq.of_array<string>((owned) array)
	.parallel()
	.filter((g) => g.length == 3)
	.map<string>((g) => g.up())
	.foreach((g) => print("%s\n", g));

// (unordered) output:
// DOG
// CAT
// PIG
```

## License

Gpseq is free software: you can redistribute it and/or modify it under
the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or (at your
option) any later version.

Gpseq is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Gpseq.  If not, see <http://www.gnu.org/licenses/>.

### Libgee

Gpseq is using a modified version of timsort.vala of libgee.
See [TimSort.vala](src/TimSort.vala) and [COPYING-libgee](COPYING-libgee).

### benchmarks.vala

Copyright and related rights of [benchmarks.vala](benchmark/benchmarks.vala) are
waived via CC0. See [COPYING-benchmarks-utility](COPYING-benchmarks-utility).
