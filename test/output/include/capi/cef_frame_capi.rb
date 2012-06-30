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
  class CefStringVisitorT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefStringVisitorT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefRequestT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefBrowserT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefV8contextT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  class CefDomvisitorT < FFI::Struct
    layout :dummy, :char
  end
  
  # (Not documented)
  # 
  # = Fields:
  # :base ::
  #   (unknown) ///
  # :is_valid ::
  #   (FFI::Pointer(*)) ///
  # :undo ::
  #   (FFI::Pointer(*)) ///
  # :redo_ ::
  #   (FFI::Pointer(*)) ///
  # :cut ::
  #   (FFI::Pointer(*)) ///
  # :copy ::
  #   (FFI::Pointer(*)) ///
  # :paste ::
  #   (FFI::Pointer(*)) ///
  # :del ::
  #   (FFI::Pointer(*)) ///
  # :select_all ::
  #   (FFI::Pointer(*)) ///
  # :view_source ::
  #   (FFI::Pointer(*)) ///
  # :get_source ::
  #   (FFI::Pointer(*)) ///
  # :get_text ::
  #   (FFI::Pointer(*)) ///
  # :load_request ::
  #   (FFI::Pointer(*)) ///
  # :load_url ::
  #   (FFI::Pointer(*)) ///
  # :load_string ::
  #   (FFI::Pointer(*)) ///
  # :execute_java_script ::
  #   (FFI::Pointer(*)) ///
  # :is_main ::
  #   (FFI::Pointer(*)) ///
  # :is_focused ::
  #   (FFI::Pointer(*)) ///
  # :get_name ::
  #   (FFI::Pointer(*)) // The resulting string must be freed by calling cef_string_userfree_free().
  # :get_identifier ::
  #   (FFI::Pointer(*)) ///
  # :get_parent ::
  #   (FFI::Pointer(*)) ///
  # :get_url ::
  #   (FFI::Pointer(*)) // The resulting string must be freed by calling cef_string_userfree_free().
  # :get_browser ::
  #   (FFI::Pointer(*)) ///
  # :get_v8context ::
  #   (FFI::Pointer(*)) ///
  # :visit_dom ::
  #   (FFI::Pointer(*)) ///
  class CefFrameT < FFI::Struct
    layout :base, :char,
           :is_valid, :pointer,
           :undo, :pointer,
           :redo_, :pointer,
           :cut, :pointer,
           :copy, :pointer,
           :paste, :pointer,
           :del, :pointer,
           :select_all, :pointer,
           :view_source, :pointer,
           :get_source, :pointer,
           :get_text, :pointer,
           :load_request, :pointer,
           :load_url, :pointer,
           :load_string, :pointer,
           :execute_java_script, :pointer,
           :is_main, :pointer,
           :is_focused, :pointer,
           :get_name, :pointer,
           :get_identifier, :pointer,
           :get_parent, :pointer,
           :get_url, :pointer,
           :get_browser, :pointer,
           :get_v8context, :pointer,
           :visit_dom, :pointer
  end
  
end
