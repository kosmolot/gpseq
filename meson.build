project('gpseq', 'vala', 'c',
	version: '0.1.0-dev',
	license: 'LGPL3')

project_desc = 'A GObject utility library providing parallel data processing'

version_ary = meson.project_version().split('.')
api_version = '@0@.@1@'.format(version_ary[0], version_ary[1])

message('gpseq version: ' + meson.project_version())
message('api version: ' + api_version)

cc = meson.get_compiler('c')

m_dep = cc.find_library('m', required: false)
glib_reqs = '2.36'
glib_dep = dependency('glib-2.0', version: '>=' + glib_reqs)
gobject_reqs = '2.36'
gobject_dep = dependency('gobject-2.0', version: '>=' + gobject_reqs)
gee_reqs = '0.18'
gee_dep = dependency('gee-0.8', version: '>=' + gee_reqs)

dependencies = [
	m_dep,
	glib_dep,
	gobject_dep,
	gee_dep
]

pkg_requires = [
	'glib-2.0 >= ' + glib_reqs,
	'gobject-2.0 >= ' + gobject_reqs,
	'gee-0.8 >= ' + gee_reqs
]

vala_args = [
	'--target-glib=' + glib_reqs,
	'--enable-experimental',
	'--verbose',
	'--thread'
]

subdir('src')
subdir('tests')
if get_option('build_benchmark')
	subdir('benchmark')
endif
