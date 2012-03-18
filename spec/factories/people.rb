# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :person do
    last_name "MyString"
    first_name "MyString"
    middle_name "MyString"
    maden "MyString"
    prefix "MyString"
    suffix "MyString"
    gender "MyString"
    birth_date "2012-03-17"
    death_date "2012-03-17"
    death_hebrew_date_day 1
    death_hebrew_date_month 1
    death_hebrew_date_year 1
    death_after_sunset false
  end
end
