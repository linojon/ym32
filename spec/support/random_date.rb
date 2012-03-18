# ref: http://www.idolhands.com/ruby-on-rails/rails-gems-plugins-and-engines/using-faker-to-pre-populate-a-dev-database

def randomDate(params={})
  years_back = params[:year_range] || 5
  latest_year  = params [:year_latest] || 0
  year = (rand * (years_back)).ceil + (Time.now.year - latest_year - years_back)
  month = (rand * 12).ceil
  day = (rand * 31).ceil
  series = [date = Time.local(year, month, day)]
  if params[:series]
    params[:series].each do |some_time_after|
      series << series.last + (rand * some_time_after).ceil
    end
    return series
  end
  date
end
