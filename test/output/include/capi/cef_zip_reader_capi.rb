# Generated by ffi-gen. Please do not change this file by hand.

require 'ffi'

module CEF
  extend FFI::Library
  ffi_lib 'cef'
  
  def self.attach_function(name, *_)
    begin; super; rescue FFI::NotFoundError => e
      (class << self; self; end).class_eval { define_method(name) { |*_| raise e } }
    end
  end
  
  # (Not documented)
  # 
  # = Fields:
  # :base ::
  #   (unknown) ///
  # :move_to_first_file ::
  #   (FFI::Pointer(*)) ///
  # :move_to_next_file ::
  #   (FFI::Pointer(*)) ///
  # :move_to_file ::
  #   (FFI::Pointer(*)) ///
  # :close ::
  #   (FFI::Pointer(*)) ///
  # :get_file_name ::
  #   (FFI::Pointer(*)) // The resulting string must be freed by calling cef_string_userfree_free().
  # :get_file_size ::
  #   (FFI::Pointer(*)) ///
  # :get_file_last_modified ::
  #   (FFI::Pointer(*)) ///
  # :open_file ::
  #   (FFI::Pointer(*)) ///
  # :close_file ::
  #   (FFI::Pointer(*)) ///
  # :read_file ::
  #   (FFI::Pointer(*)) ///
  # :tell ::
  #   (FFI::Pointer(*)) ///
  # :eof ::
  #   (FFI::Pointer(*)) ///
  class CefZipReaderT < FFI::Struct
    layout :base, :char,
           :move_to_first_file, :pointer,
           :move_to_next_file, :pointer,
           :move_to_file, :pointer,
           :close, :pointer,
           :get_file_name, :pointer,
           :get_file_size, :pointer,
           :get_file_last_modified, :pointer,
           :open_file, :pointer,
           :close_file, :pointer,
           :read_file, :pointer,
           :tell, :pointer,
           :eof, :pointer
  end
  
  # ///
  class CefStreamReaderT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  # 
  # @method zip_reader_create(stream)
  # @param [CefStreamReaderT] stream 
  # @return [CefZipReaderT] 
  # @scope class
  attach_function :zip_reader_create, :cef_zip_reader_create, [CefStreamReaderT], CefZipReaderT
  
end
