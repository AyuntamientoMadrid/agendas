module Features
  module JsHelpers
    def choose_autocomplete(field, options = {})
      page.execute_script %Q{ $('##{field}').trigger('focus'); }
      find("#event_organization_name").native.send_key(options[:with])
      sleep 1
      page.execute_script %Q{ $('li.ui-menu-item:contains("#{options[:select]}")').trigger("mouseenter").trigger("click"); }
    end

    def tinymce_fill_in(id, val)
      sleep 0.5 until page.evaluate_script("tinyMCE.get('#{id}') !== null")

      js = "tinyMCE.get('#{id}').setContent('#{val}')"
      page.execute_script(js)
    end
  end
end
