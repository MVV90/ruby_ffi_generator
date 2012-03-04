# Generated by ffi_gen. Please do not change this file by hand.

require 'ffi'

module LLVM::C
  extend FFI::Library
  ffi_lib 'LLVM-3.0'
  
  # (Not documented)
  class OpaqueObjectFile < FFI::Struct
  end
  
  # (Not documented)
  class OpaqueSectionIterator < FFI::Struct
  end
  
  # (Not documented)
  # 
  # @method create_object_file(mem_buf)
  # @param [FFI::Pointer(MemoryBufferRef)] mem_buf 
  # @return [FFI::Pointer(ObjectFileRef)] 
  # @scope class
  attach_function :create_object_file, :LLVMCreateObjectFile, [:pointer], :pointer
  
  # (Not documented)
  # 
  # @method dispose_object_file(object_file)
  # @param [FFI::Pointer(ObjectFileRef)] object_file 
  # @return [nil] 
  # @scope class
  attach_function :dispose_object_file, :LLVMDisposeObjectFile, [:pointer], :void
  
  # (Not documented)
  # 
  # @method get_sections(object_file)
  # @param [FFI::Pointer(ObjectFileRef)] object_file 
  # @return [FFI::Pointer(SectionIteratorRef)] 
  # @scope class
  attach_function :get_sections, :LLVMGetSections, [:pointer], :pointer
  
  # (Not documented)
  # 
  # @method dispose_section_iterator(si)
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [nil] 
  # @scope class
  attach_function :dispose_section_iterator, :LLVMDisposeSectionIterator, [:pointer], :void
  
  # (Not documented)
  # 
  # @method is_section_iterator_at_end(object_file, si)
  # @param [FFI::Pointer(ObjectFileRef)] object_file 
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [Integer] 
  # @scope class
  attach_function :is_section_iterator_at_end, :LLVMIsSectionIteratorAtEnd, [:pointer, :pointer], :int
  
  # (Not documented)
  # 
  # @method move_to_next_section(si)
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [nil] 
  # @scope class
  attach_function :move_to_next_section, :LLVMMoveToNextSection, [:pointer], :void
  
  # (Not documented)
  # 
  # @method get_section_name(si)
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [String] 
  # @scope class
  attach_function :get_section_name, :LLVMGetSectionName, [:pointer], :string
  
  # (Not documented)
  # 
  # @method get_section_size(si)
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [Integer] 
  # @scope class
  attach_function :get_section_size, :LLVMGetSectionSize, [:pointer], :ulong
  
  # (Not documented)
  # 
  # @method get_section_contents(si)
  # @param [FFI::Pointer(SectionIteratorRef)] si 
  # @return [String] 
  # @scope class
  attach_function :get_section_contents, :LLVMGetSectionContents, [:pointer], :string
  
end
