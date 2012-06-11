def wait_for_ajax
  wait_until { page.evaluate_script("typeof(jQuery)!='undefined' && jQuery.active") == 0 }
end
