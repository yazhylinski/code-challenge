# frozen_string_literal: true

require 'fileutils'
require 'httparty'

module SmashingMagazineParser
  class SaveImagesService
    # @wallpapers Array<SmasingMagazineParser::Wallpaper>
    # @subdir String
    def initialize(wallpapers, subdir)
      self.wallpapers = wallpapers
      self.subdir = subdir
    end

    def call
      create_images_folder
      save_wallpapers
    end

    private

    def create_images_folder
      FileUtils.mkdir_p images_folder
    end

    def images_folder
      "#{ENV.fetch('SMASHING_MAGAZINE_PARSER_IMAGES_FOLDER')}/#{subdir}"
    end

    def wallpaper_folder(wallpaper)
      "#{images_folder}/#{wallpaper.name}/"
    end

    def save_wallpapers
      wallpapers.each_with_index do |wallpaper, w_index|
        Logger.info(
          "#{w_index + 1}/#{wallpapers.length}. " \
          "Starting to save wallpaper: #{wallpaper.name}. Total #{wallpaper.links.length} images"
        )

        FileUtils.mkdir_p wallpaper_folder(wallpaper)
        save_images(wallpaper)

        Logger.info("Finished to save wallpaper: #{wallpaper.name}")
      end
    end

    def save_images(wallpaper)
      wallpaper.links.each_with_index do |link, l_index|
        File.write("#{wallpaper_folder(wallpaper)}#{link_filename(link)}.#{link.extension}",
                   HTTParty.get(link.url, follow_redirects: true).body)

        Logger.info("\t#{l_index + 1}/#{wallpaper.links.length} Done")
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

    attr_accessor :wallpapers, :subdir
  end
end
