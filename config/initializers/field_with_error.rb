# This is needed otherwise the div element with error gets class field_with_error
ActionView::Base.field_error_proc = Proc.new { |html_tag, instance| html_tag.html_safe }
