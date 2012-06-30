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
  # :clear ::
  #   (FFI::Pointer(*)) ///
  # :get_count ::
  #   (FFI::Pointer(*)) ///
  # :add_separator ::
  #   (FFI::Pointer(*)) ///
  # :add_item ::
  #   (FFI::Pointer(*)) ///
  # :add_check_item ::
  #   (FFI::Pointer(*)) ///
  # :add_radio_item ::
  #   (FFI::Pointer(*)) ///
  # :add_sub_menu ::
  #   (FFI::Pointer(*)) ///
  # :insert_separator_at ::
  #   (FFI::Pointer(*)) ///
  # :insert_item_at ::
  #   (FFI::Pointer(*)) ///
  # :insert_check_item_at ::
  #   (FFI::Pointer(*)) ///
  # :insert_radio_item_at ::
  #   (FFI::Pointer(*)) ///
  # :insert_sub_menu_at ::
  #   (FFI::Pointer(*)) ///
  # :remove ::
  #   (FFI::Pointer(*)) ///
  # :remove_at ::
  #   (FFI::Pointer(*)) ///
  # :get_index_of ::
  #   (FFI::Pointer(*)) ///
  # :get_command_id_at ::
  #   (FFI::Pointer(*)) ///
  # :set_command_id_at ::
  #   (FFI::Pointer(*)) ///
  # :get_label ::
  #   (FFI::Pointer(*)) // The resulting string must be freed by calling cef_string_userfree_free().
  # :get_label_at ::
  #   (FFI::Pointer(*)) // The resulting string must be freed by calling cef_string_userfree_free().
  # :set_label ::
  #   (FFI::Pointer(*)) ///
  # :set_label_at ::
  #   (FFI::Pointer(*)) ///
  # :get_type ::
  #   (FFI::Pointer(*)) ///
  # :get_type_at ::
  #   (FFI::Pointer(*)) ///
  # :get_group_id ::
  #   (FFI::Pointer(*)) ///
  # :get_group_id_at ::
  #   (FFI::Pointer(*)) ///
  # :set_group_id ::
  #   (FFI::Pointer(*)) ///
  # :set_group_id_at ::
  #   (FFI::Pointer(*)) ///
  # :get_sub_menu ::
  #   (FFI::Pointer(*)) ///
  # :get_sub_menu_at ::
  #   (FFI::Pointer(*)) ///
  # :is_visible ::
  #   (FFI::Pointer(*)) ///
  # :is_visible_at ::
  #   (FFI::Pointer(*)) ///
  # :set_visible ::
  #   (FFI::Pointer(*)) ///
  # :set_visible_at ::
  #   (FFI::Pointer(*)) ///
  # :is_enabled ::
  #   (FFI::Pointer(*)) ///
  # :is_enabled_at ::
  #   (FFI::Pointer(*)) ///
  # :set_enabled ::
  #   (FFI::Pointer(*)) ///
  # :set_enabled_at ::
  #   (FFI::Pointer(*)) ///
  # :is_checked ::
  #   (FFI::Pointer(*)) ///
  # :is_checked_at ::
  #   (FFI::Pointer(*)) ///
  # :set_checked ::
  #   (FFI::Pointer(*)) ///
  # :set_checked_at ::
  #   (FFI::Pointer(*)) ///
  # :has_accelerator ::
  #   (FFI::Pointer(*)) ///
  # :has_accelerator_at ::
  #   (FFI::Pointer(*)) ///
  # :set_accelerator ::
  #   (FFI::Pointer(*)) ///
  # :set_accelerator_at ::
  #   (FFI::Pointer(*)) ///
  # :remove_accelerator ::
  #   (FFI::Pointer(*)) ///
  # :remove_accelerator_at ::
  #   (FFI::Pointer(*)) ///
  # :get_accelerator ::
  #   (FFI::Pointer(*)) ///
  # :get_accelerator_at ::
  #   (FFI::Pointer(*)) ///
  class CefMenuModelT < FFI::Struct
    layout :base, :char,
           :clear, :pointer,
           :get_count, :pointer,
           :add_separator, :pointer,
           :add_item, :pointer,
           :add_check_item, :pointer,
           :add_radio_item, :pointer,
           :add_sub_menu, :pointer,
           :insert_separator_at, :pointer,
           :insert_item_at, :pointer,
           :insert_check_item_at, :pointer,
           :insert_radio_item_at, :pointer,
           :insert_sub_menu_at, :pointer,
           :remove, :pointer,
           :remove_at, :pointer,
           :get_index_of, :pointer,
           :get_command_id_at, :pointer,
           :set_command_id_at, :pointer,
           :get_label, :pointer,
           :get_label_at, :pointer,
           :set_label, :pointer,
           :set_label_at, :pointer,
           :get_type, :pointer,
           :get_type_at, :pointer,
           :get_group_id, :pointer,
           :get_group_id_at, :pointer,
           :set_group_id, :pointer,
           :set_group_id_at, :pointer,
           :get_sub_menu, :pointer,
           :get_sub_menu_at, :pointer,
           :is_visible, :pointer,
           :is_visible_at, :pointer,
           :set_visible, :pointer,
           :set_visible_at, :pointer,
           :is_enabled, :pointer,
           :is_enabled_at, :pointer,
           :set_enabled, :pointer,
           :set_enabled_at, :pointer,
           :is_checked, :pointer,
           :is_checked_at, :pointer,
           :set_checked, :pointer,
           :set_checked_at, :pointer,
           :has_accelerator, :pointer,
           :has_accelerator_at, :pointer,
           :set_accelerator, :pointer,
           :set_accelerator_at, :pointer,
           :remove_accelerator, :pointer,
           :remove_accelerator_at, :pointer,
           :get_accelerator, :pointer,
           :get_accelerator_at, :pointer
  end
  
end
