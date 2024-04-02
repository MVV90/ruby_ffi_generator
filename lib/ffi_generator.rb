require 'ffi'

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

require 'ffi_generator/generators/from_c_generator/generator'
require 'ffi_generator/generators/from_c_generator/type'
require 'ffi_generator/generators/from_c_generator/array_type'
require 'ffi_generator/generators/from_c_generator/by_value_type'
require 'ffi_generator/generators/from_c_generator/define'
require 'ffi_generator/generators/from_c_generator/enum'
require 'ffi_generator/generators/from_c_generator/function_or_callback'
require 'ffi_generator/generators/from_c_generator/name'
require 'ffi_generator/generators/from_c_generator/pointer_type'
require 'ffi_generator/generators/from_c_generator/primitive_type'
require 'ffi_generator/generators/from_c_generator/string_type'
require 'ffi_generator/generators/from_c_generator/struct_or_union'
require 'ffi_generator/generators/from_c_generator/unknown_type'
require 'ffi_generator/generators/from_c_generator/writer'
require 'ffi_generator/generators/from_c_generator/ruby'

# TODO: dynamically require what we need based on the request.
#
# require 'ffi_generator/generators/from_java_generator/generator'
# require 'ffi_generator/generators/from_java_generator/type'
# require 'ffi_generator/generators/from_java_generator/array_type'
# require 'ffi_generator/generators/from_java_generator/by_value_type'
# require 'ffi_generator/generators/from_java_generator/define'
# require 'ffi_generator/generators/from_java_generator/enum'
# require 'ffi_generator/generators/from_java_generator/function_or_callback'
# require 'ffi_generator/generators/from_java_generator/name'
# require 'ffi_generator/generators/from_java_generator/pointer_type'
# require 'ffi_generator/generators/from_java_generator/primitive_type'
# require 'ffi_generator/generators/from_java_generator/string_type'
# require 'ffi_generator/generators/from_java_generator/struct_or_union'
# require 'ffi_generator/generators/from_java_generator/unknown_type'
# require 'ffi_generator/generators/from_java_generator/writer'
# require 'ffi_generator/generators/from_java_generator/java'

module FFIGenerate
  def self.generate(options = {})
    Generator.new(options).generate
  end
end

# if __FILE__ == $0
#   FFIGenerate.generate(
#     module_name: "FFIGenerate::Clang::C",
#     ffi_lib:     'clang-15',
#     headers:     ["clang-c/CXErrorCode.h", "clang-c/CXString.h", "clang-c/Index.h"],
#     cflags:      `llvm-config-15 --cflags`.split(" "),
#     prefixes:    ["clang_", "CX"],
#     output:      File.join(File.dirname(__FILE__), "ffi_generator/clang/c.rb")
#   )
# end
