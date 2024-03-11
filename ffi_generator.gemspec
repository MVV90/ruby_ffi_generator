Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY

  s.name = "ffi_generator"
  s.version = "1.0.0"
  s.summary = "Ruby FFI bindings generator"
  s.description = "Ruby FFI bindings generator for C/C++ header files (via LLVM Clang)"
  s.author = ""
  s.email = ""
  s.homepage = "https://github.com/MVV90/ruby_ffi_generator"
  s.license = "MIT"

  s.add_dependency "ffi", "~> 1.0"
  s.files = Dir["lib/**/*.rb"] + ["LICENSE", "README.md", "lib/ffi_generator/empty.h"]
  s.require_path = "lib"
end
