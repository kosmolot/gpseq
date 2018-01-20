benchmark_sources = files(
	'benchmark.vala',
	'benchmarks.vala'
)

benchmark_deps = [
	gpseq_dep
]

executable('gpseq-benchmark', benchmark_sources,
	dependencies: [dependencies, benchmark_deps],
	vala_args: [vala_args, '--pkg=posix'])
