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
  # :size ::
  #   (Integer) ///
  # :add_ref ::
  #   (FFI::Pointer(*)) ///
  # :release ::
  #   (FFI::Pointer(*)) ///
  # :get_refct ::
  #   (FFI::Pointer(*)) ///
  class CefBaseT < FFI::Struct
    layout :size, :ulong,
           :add_ref, :pointer,
           :release, :pointer,
           :get_refct, :pointer
  end
  
end
