ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
  html_tag.html_safe
}

#ActionView::Base.field_error_proc = Proc.new { |html_tag, instance|
  #%(<span class="fieldWithErrors2">#{html_tag}</span>).html_safe
#}
