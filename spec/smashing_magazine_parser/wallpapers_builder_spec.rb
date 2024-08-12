# frozen_string_literal: true

require_relative '../spec_helper'

require 'nokogiri'
require 'open-uri'

RSpec.describe SmashingMagazineParser::WallpapersBuilder do
  describe '#build' do
    it 'returns list of all wallpapers with links' do
      doc = Nokogiri::HTML(File.open('spec/fixtures/smashing_magazine_response.html'))
      wallpapers = described_class.new(doc).build

      expect(wallpapers.count).to eq(32)
      expect(wallpapers[0].name).to eq('Cheerful Chimes City')
      expect(wallpapers[0].links.count).to eq(17)

      expect(wallpapers[0].links.count(&:preview)).to eq(1)

      expect(wallpapers[0].links.count(&:with_calendar)).to eq(9) # + 1 preview
      expect(wallpapers[0].links.count { !_1.with_calendar }).to eq(8)

      # Verify that all wallpapers have links
      expect(wallpapers.filter { _1.links.count > 0 }.count).to eq(32)
    end
  end
end
