# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe SmashingMagazineParser::SaveImagesService do
  before do
    FileUtils.remove_dir('test_images')
  end

  describe '#call' do
    let(:date) { Date.new(2023, 1, 1) }

    it 'creates a folder for images' do
      described_class.new([], date).call

      expect(File.directory?('test_images/2023/1')).to eq(true)

      # Check that it's not raise error if it's called twice
      described_class.new([], date).call
    end

    it 'creates a folder for wallpaper' do
      described_class.new(
        [
          instance_double('SmashingMagazineParser::Wallpaper', name: 'wp', links: [])
        ],
        date
      ).call

      expect(File.directory?('test_images/2023/1/wp')).to eq(true)

      # Check that it's not raise error if it's called twice
      described_class.new([], date).call
    end

    it 'uploads image to wallpaper folder' do
      stub_request(:get, 'http://mag.com/1.jpg')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: 'FIRST FILE', headers: {})

      stub_request(:get, 'http://mag.com/2.jpg')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: 'SECOND FILE', headers: {})

      described_class.new(
        [
          instance_double('SmashingMagazineParser::Wallpaper', name: 'wp', links: [
                            instance_double(
                              'SmashingMagazineParser::WallpaperLink',
                              url: 'http://mag.com/1.jpg',
                              preview: true,
                              size: nil,
                              with_calendar: false,
                              extension: 'jpg'
                            ),
                            instance_double(
                              'SmashingMagazineParser::WallpaperLink',
                              url: 'http://mag.com/2.jpg',
                              preview: nil,
                              size: '3x4',
                              with_calendar: true,
                              extension: 'jpg'
                            )
                          ])
        ],
        date
      ).call

      expect(File.exist?('test_images/2023/1/wp/preview.jpg')).to eq(true)
      expect(File.exist?('test_images/2023/1/wp/with calendar 3x4.jpg')).to eq(true)

      # Check that it's not raise error if it's called twice
      described_class.new([], date).call
    end
  end
end
