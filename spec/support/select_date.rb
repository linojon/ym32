# ref: https://gist.github.com/558786, modified for simple_form (vs formtastic)

def select_date(field, options = {})
  date     = Date.parse(options[:with])
  selector = %Q{.//div[contains(./label, "#{field}")]}
  within(:xpath, selector) do
    find(:xpath, './/select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(date.year.to_s)).select_option
    find(:xpath, './/select[contains(@id, "_2i")]').find(:xpath, ::XPath::HTML.option(date.strftime('%B').to_s)).select_option
    find(:xpath, './/select[contains(@id, "_3i")]').find(:xpath, ::XPath::HTML.option(date.day.to_s)).select_option
  end
end

def select_year(field, options = {})
  year     = options[:with]
  selector = %Q{.//div[contains(./label, "#{field}")]}
  within(:xpath, selector) do
    find(:xpath, './/select[contains(@id, "_1i")]').find(:xpath, ::XPath::HTML.option(year.to_s)).select_option
  end
end


