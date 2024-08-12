# frozen_string_literal: true

require 'fileutils'
require 'httparty'

module SmashingMagazineParser
  class SaveImagesService
    # @wallpapers Array<SmasingMagazineParser::Wallpaper>
    # @date Date
    def initialize(wallpapers, date)
      self.wallpapers = wallpapers
      self.date = date
    end

    def call
      create_images_folder
      save_images
    end

    private

    def create_images_folder
      FileUtils.mkdir_p images_folder
    end

    def images_folder
      "#{ENV.fetch('SMASHING_MAGAZINE_PARSER_IMAGES_FOLDER')}/#{date.year}/#{date.month}"
    end

    def wallpaper_folder(wallpaper)
      "#{images_folder}/#{wallpaper.name}/"
    end

    def save_images
      wallpapers.each do |wallpaper|
        FileUtils.mkdir_p wallpaper_folder(wallpaper)

        wallpaper.links.each do |link|
          File.write("#{wallpaper_folder(wallpaper)}#{link_filename(link)}.#{link.extension}",
                     HTTParty.get(link.url, follow_redirects: true).body)
        end
      end
    end

    def link_filename(link)
      return 'preview' if link.preview

      name = ''

      name += if link.with_calendar
                'with calendar'
              else
                'without calendar'
              end

      name += " #{link.size}" if link.size

      name
    end

    attr_accessor :wallpapers, :date
  end
end
