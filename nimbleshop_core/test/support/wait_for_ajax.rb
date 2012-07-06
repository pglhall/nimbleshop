def wait_for_ajax
  # TODO delete me noone is using me
  wait_until { page.evaluate_script("typeof(jQuery)!='undefined' && jQuery.active") == 0 }
end
