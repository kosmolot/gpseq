test_sources = files(
	'IntSeqTests.vala',
	'NullableIntSeqTests.vala',
	'NullableStringSeqTests.vala',
	'SeqTests.vala',
	'StringSeqTests.vala',
	'SubArrayTests.vala',
	'TestSuite.vala',
	'TestUtils.vala',
	'UtilsTests.vala',
	'test.vala'
)

test_deps = [
	gpseq_dep
]

gpseq_test = executable('gpseq-test', test_sources,
	dependencies: [dependencies, test_deps],
	vala_args: vala_args)
test('test', gpseq_test)
