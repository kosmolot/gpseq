benchmark_sources = files(
	'benchmark-chop.vala',
	'benchmark-collect.vala',
	'benchmark-complex.vala',
	'benchmark-filter.vala',
	'benchmark-find.vala',
	'benchmark-flat-map.vala',
	'benchmark-map.vala',
	'benchmark-max.vala',
	'benchmark-reduce.vala',
	'benchmark-sort.vala',
	'benchmark.vala',
	'benchmarks.vala',
	'utils.vala'
)

benchmark_deps = [
	gpseq_dep
]

executable('gpseq-benchmark', benchmark_sources,
	dependencies: [dependencies, benchmark_deps],
	vala_args: [vala_args, '--pkg=posix'])
