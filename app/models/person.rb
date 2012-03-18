require 'capitalize_name'
require 'hebrew_date'
require 'proper_name_validator'

class Person < ActiveRecord::Base
  #extend ActiveSupport::Memoizable
  
  def full_name
    [ prefix, first_name, middle_name, last_name, suffix ].join(' ')
  end
  def last_first_name
    [ last_name + ',', first_name, middle_name, suffix ].join(' ')
  end
  
  composed_of :death_hebrew_date, 
              :class_name => 'Hebruby::HebrewDate', 
              :mapping => 
              [ # database            # HebrewDate
                [:death_hebrew_date_day,   :day], 
                [:death_hebrew_date_month, :month], 
                [:death_hebrew_date_year,  :year]
              ],
             :allow_nil => true
    
  GENDERS = %w{ male female }
  validates :gender, :inclusion => { :in => GENDERS }, :allow_blank => true
  
  PREFIXES = %w{ Ms Miss Mrs Mr Dr Atty Prof Hon Gov Ofc Rabbi Cantor }
  validates :prefix, :inclusion => { :in => PREFIXES }, :allow_blank => true
  
  validates :last_name,   :presence => true, 
                          :length => { :minimum => 2 },
                          :proper_name => true
                          
  validates :first_name,  :presence => true,
                          :proper_name => true
                          
  validates :maiden,      :proper_name => true,
                          :allow_blank => true
                          
  validates :middle_name, :proper_name => true,
                          :allow_blank => true
  
  validate :death_date_cannot_be_before_birth_date
  

  def death_date_cannot_be_before_birth_date
    if !death_date.blank? and !birth_date.blank? and death_date < birth_date
      errors.add(:death_date, "can't be before birth date")
    end
  end
  
  before_save :strip_and_capitalize_names
  before_save :set_death_dates
  
  # get next yahrzeit date on or after "from" date
  def next_yahrzeit_date(from=Date.today)
    return unless death_date
    # TODO: use Marlena rules
    h_from = Hebruby::HebrewDate.new(from)
    h_death = Hebruby::HebrewDate.new(death_date)
    # yahrzeit date from year
    h_yahrzeit = Hebruby::HebrewDate.new(h_death.day, h_death.month, h_from.year)
    date = Date.jd(h_yahrzeit.jd)
    if date < from
      h_yahrzeit = Hebruby::HebrewDate.new(h_death.day, h_death.month, h_from.year+1)
      date = Date.jd(h_yahrzeit.jd)
    end
    date
  end
  
  ### callbacks
  
  def strip_and_capitalize_names
    self.last_name.strip! unless last_name.nil?
    self.first_name.strip! unless first_name.nil?
    self.middle_name.strip! unless middle_name.nil?
    self.maiden.strip! unless maiden.nil?
    
    self.last_name.capitalize_name! if last_name.present?
    self.first_name.capitalize_name! if first_name.present?
    self.middle_name.capitalize_name! if middle_name.present?
    self.maiden.capitalize_name! if maiden.present?
  end
  
  def set_death_dates
    if death_hebrew_date.nil? && death_date.present?
      date = death_date
      date += 1.day if death_after_sunset
      self.death_hebrew_date = Hebruby::HebrewDate.new(date) 
    end
    if death_date.nil? && death_hebrew_date.present?
      jd =  death_hebrew_date.jd
      jd -= 1 if death_after_sunset
      self.death_date = Date.jd(jd) 
    end
  end
  
end
