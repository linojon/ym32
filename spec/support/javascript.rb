def trigger_change_event(field)
  unless page.has_selector?(field)
    field = page.find(:css, "label:contains('#{field}')")[:for]
  end
  page.execute_script("$('##{field}').trigger('change');")
end

def trigger_blur_event(field)
  unless page.has_selector?(field)
    field = page.find(:css, "label:contains('#{field}')")[:for]
  end
  page.execute_script("$('##{field}').trigger('blur');")
end


# module Capybara::DSL
#   def fill_in(field, value)
#     super
#     debugger
#     trigger_blur_event field if Capybara.javascript_driver == :selenium  
#   end
# end
