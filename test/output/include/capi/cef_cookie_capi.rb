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
  class CefCookieVisitorT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefCookieVisitorT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  # 
  # = Fields:
  # :base ::
  #   (unknown) ///
  # :set_supported_schemes ::
  #   (FFI::Pointer(*)) ///
  # :visit_all_cookies ::
  #   (FFI::Pointer(*)) ///
  # :visit_url_cookies ::
  #   (FFI::Pointer(*)) ///
  # :set_cookie ::
  #   (FFI::Pointer(*)) ///
  # :delete_cookies ::
  #   (FFI::Pointer(*)) ///
  # :set_storage_path ::
  #   (FFI::Pointer(*)) ///
  class CefCookieManagerT < FFI::Struct
    layout :base, :char,
           :set_supported_schemes, :pointer,
           :visit_all_cookies, :pointer,
           :visit_url_cookies, :pointer,
           :set_cookie, :pointer,
           :delete_cookies, :pointer,
           :set_storage_path, :pointer
  end
  
  # (Not documented)
  # 
  # @method cookie_manager_get_global_manager()
  # @return [CefCookieManagerT] 
  # @scope class
  attach_function :cookie_manager_get_global_manager, :cef_cookie_manager_get_global_manager, [], CefCookieManagerT
  
  # (Not documented)
  # 
  # @method cookie_manager_create_manager(path)
  # @param [FFI::Pointer(*StringT)] path 
  # @return [CefCookieManagerT] 
  # @scope class
  attach_function :cookie_manager_create_manager, :cef_cookie_manager_create_manager, [:pointer], CefCookieManagerT
  
  # ///
  # 
  # = Fields:
  # :base ::
  #   (unknown) ///
  # :visit ::
  #   (FFI::Pointer(*)) ///
  class CefCookieVisitorT < FFI::Struct
    layout :base, :char,
           :visit, :pointer
  end
  
end
