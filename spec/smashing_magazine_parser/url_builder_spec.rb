# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe SmashingMagazineParser::UrlBuilder do
  describe '#build' do
    it 'returns correct url for specific month and year' do
      expect(described_class.new(Date.new(2023, 1, 1)).build).to include(
        'www.smashingmagazine.com/2023/01/desktop-wallpaper-calendars-february-2023'
      )
    end

    it 'returns next year first month name' do
      expect(described_class.new(Date.new(2023, 12, 1)).build).to include(
        'www.smashingmagazine.com/2023/12/desktop-wallpaper-calendars-january-2024'
      )
    end
  end
end
