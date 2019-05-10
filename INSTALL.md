# Building gpseq

## Build requirements

- valac
- meson >= 0.44
- ninja (or other meson backend to use)
- valadoc (optional; to build documentation)
- gtk-doc-tools (optional; to build gtkdoc)

### Dependencies

- glib-2.0 >= 2.48
- gobject-2.0 >= 2.48
- gee-0.8 >= 0.18
- posix (optional; to build benchmark) -- included in vala vapis

## Build

1. `cd <project-root>`
2. `meson build --buildtype=release`

### Test

After meson build:

1. `ninja -C build`
2. `meson test -C build -t 5 --print-errorlogs --verbose`

### Install

Run `sudo ninja install -C build` after meson build.

To uninstall: `sudo ninja uninstall -C build`

### Build options

- build_benchmark: Whether to build benchmark (type: boolean, default: false)
- build_doc: Documentations that will be built (type: array, choices: [valadoc, gtkdoc], default: [])
