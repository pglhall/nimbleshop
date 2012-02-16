module NootstrapHelper

  def display_variant_info(line_item)
    return if line_item.variant_info.blank?
    "[#{line_item.variant_info}]"
  end

end
