require 'ffi'

require 'ffi_generator/clang'
require 'ffi_generator/clang/c'
require 'ffi_generator/clang/c/type'
require 'ffi_generator/clang/cursor'
require 'ffi_generator/clang/index'
require 'ffi_generator/clang/source_location'
require 'ffi_generator/clang/source_range'
require 'ffi_generator/clang/string'
require 'ffi_generator/clang/token'
require 'ffi_generator/clang/translation_unit'
require 'ffi_generator/clang/type'
require 'ffi_generator/generator'
require 'ffi_generator/generator/type'
require 'ffi_generator/generator/array_type'
require 'ffi_generator/generator/by_value_type'
require 'ffi_generator/generator/define'
require 'ffi_generator/generator/enum'
require 'ffi_generator/generator/function_or_callback'
require 'ffi_generator/generator/name'
require 'ffi_generator/generator/pointer_type'
require 'ffi_generator/generator/primitive_type'
require 'ffi_generator/generator/string_type'
require 'ffi_generator/generator/struct_or_union'
require 'ffi_generator/generator/unknown_type'
require 'ffi_generator/generator/writer'
require 'ffi_generator/generator/java'
require 'ffi_generator/generator/ruby'


module FFIGen

  def self.generate(options = {})
    Generator.new(options).generate
  end

end


if __FILE__ == $0
  FFIGen.generate(
    module_name: "FFIGen::Clang::C",
    ffi_lib:     'clang-15',
    headers:     ["clang-c/CXErrorCode.h", "clang-c/CXString.h", "clang-c/Index.h"],
    cflags:      `llvm-config-15 --cflags`.split(" "),
    prefixes:    ["clang_", "CX"],
    output:      File.join(File.dirname(__FILE__), "ffi_generator/clang/c.rb")
  )
end
