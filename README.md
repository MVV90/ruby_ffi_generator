# A generator for Ruby FFI bindings

- *Original Author:* Richard Musiol
- *Contributors:* Jeremy Voorhis (thanks for the initial idea)
- *License:* MIT (see LICENSE)


## Features

* Generation of FFI methods, structures, unions, enumerations and callbacks
* Generation of YARD documentation comments
* Tested with headers of the following libraries:
  * Cairo
  * CEF (Chromium Embedded Framework)
  * Clang
  * LibSSH2
  * LLVM
  * OpenGL
  * SQLite3


## Requirements

* Ruby 1.9
* Clang 15 (download the binaries [here](http://llvm.org/releases/download.html) or use the install script [here](https://apt.llvm.org) or build from source configured with ``--enable-shared``)

*These requirements are only for running the generator. The generated files are Ruby 1.8 compatible and do not need Clang.*

You can follow the [quickstart](quickstart.md) guide to install everything in a docker container and try out this gem.

## Example

Use the following interface in a script or Rake task:

```ruby
require "ffi_generator"

FFIGenerate.generate(
  module_name: "Clang",
  ffi_lib:     "clang",
  headers:     ["clang-c/Index.h"],
  cflags:      `llvm-config --cflags`.split(" "),
  prefixes:    ["clang_", "CX"],
  output:      "clang-c/index.rb"
)
```

Output: [clang-c/index.rb](https://github.com/MVV90/ruby_ffi_generator/blob/main/test/output/clang-c/Index.rb)

Other generated files can be found in the [test/output](https://github.com/MVV90/ruby_ffi_generator/tree/main/test/output) directory.


## Hints

You may need to set additional include directories:

```
export CPATH=/usr/lib/gcc/x86_64-linux-gnu/4.6.1/include
```

Your GCC include paths can be seen with:

```
`gcc -print-prog-name=cc1` -v
```
