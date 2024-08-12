# frozen_string_literal: true

module SmashingMagazineParser
  class WallpaperLink
    attr_reader :url, :size, :preview, :with_calendar

    def initialize(url, size, preview, with_calendar)
      self.url = url
      self.size = size

      self.preview = preview
      self.with_calendar = with_calendar
    end

    private

    attr_writer :url, :size, :preview, :with_calendar
  end
end
