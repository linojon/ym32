class HebrewDateInput < SimpleForm::Inputs::Base
  # for use with Hebruby::HebrewDate class object
  def input
    # TODO: :start_year, :end_year
    start_year = Hebruby::HebrewDate.today.year
    end_year = start_year - 200
    # handle composed_of 
    [
      @builder.select( [attribute_name,:day].join('_'), 1..30, :include_blank => true),
      @builder.select( [attribute_name,:month].join('_'), Hebruby::HebrewDate.months_for_select, :include_blank => true),
      @builder.select( [attribute_name,:year].join('_'), start_year.downto(end_year).map {|i| i}, :include_blank => true)
    ].join(' ').html_safe
    
    
    # # TODO: :start_year, :end_year
    # start_year = Hebruby::HebrewDate.today.year
    # end_year = start_year - 200
    # #debugger
    # @builder.simple_fields_for attribute_name, :validate => false do |form|
    #   form.select(:day, 1..30, :include_blank => true) + ' ' +
    #   form.select(:month, Hebruby::HebrewDate.months_for_select, :include_blank => true) + ' ' +
    #   form.select(:year, start_year.downto(end_year).map {|i| i}, :include_blank => true)
    # end
  end
end

