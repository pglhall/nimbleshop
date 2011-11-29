class LiquidHandler
  PROTECTED_ASSIGNS = %w( template_root response _session template_class action_name request_origin session template
                          _response url _request _cookies variables_added _flash params _headers request cookies
                          ignore_missing_templates flash _params logger before_filter_chain_aborted headers )

  def self.call(template)
    new.compile(template)
  end

  def compile(template)
    <<-LIQUID
      variables = assigns.reject{ |k,v| LiquidHandler::PROTECTED_ASSIGNS.include?(k) }

      if content_for_layout = instance_variable_get("@content_for_layout")
        variables['content_for_layout'] = content_for_layout
      end
      variables.merge!(local_assigns.stringify_keys)

      liquid = Liquid::Template.parse("#{template.source.gsub(/\"/, '\\\"')}")
      liquid.render(variables, :registers => {:action_view => self, :controller => controller})
    LIQUID
  end
end
::ActionView::Template.register_template_handler(:liquid, LiquidHandler)



module LiquidFilters
  include ActionView::Helpers::NumberHelper

  def currency(price)
    number_to_currency(price)
  end
end
::Liquid::Template.register_filter(LiquidFilters)
