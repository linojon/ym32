# JL: derived from cucumber selectors.rb etc

def selector_for(locator)
  case locator
    
  when /row containing "(.+)"/
    "tr:contains('#{$1}')"
    
  when /input with label "(.+)"/
    [:xpath, %Q{.//div[contains(./label, "#{$1}")]}]
    
  else
    raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
      "Now, go and add a mapping in #{__FILE__}"
  end
end

def within_input_for(label, &block )
  within( :xpath, %Q{.//div[contains(./label, "#{label}")]}, &block)
end

