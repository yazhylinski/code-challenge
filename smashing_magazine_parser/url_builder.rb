# frozen_string_literal: true

# There is a pattern to get wallpapers page by
# month and year. It's much easier to build it
# instead of try to reach it from dom.
module SmashingMagazineParser
  class UrlBuilder
    WALLPAPERS_URL_PATTERN =
      'https://www.smashingmagazine.com/:year/:month_number/desktop-wallpaper-calendars-:next_month_string-:next_year/'

    def initialize(date)
      self.date = date
    end

    def build
      WALLPAPERS_URL_PATTERN
        .gsub(':year', date.year.to_s)
        .gsub(':month_number', month_number)
        .gsub(':next_month_string', next_month_string)
        .gsub(':next_year', next_year)
    end

    private

    def month_number
      # 0-9 month requires 2 digits format otherwise 404
      date.month < 10 ? "0#{date.month}" : date.month.to_s
    end

    def next_month_string
      # For month name it requires next month name
      next_month = date.month + 1

      next_month = 1 if date.month == 12

      Date::MONTHNAMES[next_month].downcase
    end

    # In case of wallpapers in december we should return next year.
    def next_year
      date.month == 12 ? (date.year + 1).to_s : date.year.to_s
    end

    attr_accessor :date
  end
end
