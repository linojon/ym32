class Hebruby::HebrewDate
  include Comparable
  
  def to_s(format = :day_month_year)
    case format
    when :day_month
      "#{day} #{month_name}"
    else # :day_month_year
      "#{day} #{month_name} #{year}"
    end
  end
  
  def ==(other_date)
    jd == other_date.jd if other_date.is_a? Hebruby::HebrewDate
  end

  def <=>(other_date)
    jd <=> other_date.jd if other_date.is_a? Hebruby::HebrewDate
  end
  
  # new object from string "dd month yyyy"
  def self.parse(hebstr)
    if hebstr.include? 'Sheni'
      day, month, sheni, year = hebstr.split(' ')
      hm = 13
    else
      day, month, year = hebstr.split(' ')
      hm = MONTH_NAMES.find_index {|m| m==month}
    end
    self.new( day.to_i, hm, year.to_i)
  end
  
  def self.today
    @today ||= Hebruby::HebrewDate.new(Date.today.jd)
  end
  
  def self.months_for_select
    1.upto(13).map {|i| [Hebruby::HebrewDate::MONTH_NAMES[i], i] }
  end
end
