# frozen_string_literal: true

require 'httparty'

require_relative 'unable_to_recognize_image_error'

module SmashingMagazineParser
  class FilteringService
    # @wallpapers Array<SmasingMagazineParser::Wallpaper>
    # @strategy ::AnthropicCloude::RecognizeImageByThemeStrategy
    def initialize(wallpapers, strategy)
      self.wallpapers = wallpapers
      self.strategy = strategy
    end

    def call
      wallpapers.filter do |wallpaper|
        # Pick preview as it has smallest size
        min_size_link = wallpaper.links.filter { !_1.size.nil? }.min { |a, b| a.calculated_size <=> b.calculated_size }

        matched_theme = match_theme?(min_size_link)

        Logger.info("Wallpaper \"#{wallpaper.name}\" is#{matched_theme ? '' : ' not'} matched the theme")

        matched_theme
      rescue ::SmashingMagazineParser::UnableToRecognizeImageError => e
        Logger.error(e)
        false
      end
    end

    private

    attr_accessor :wallpapers, :strategy

    def match_theme?(link)
      strategy.match_theme?(
        link.extension,
        HTTParty.get(link.url, follow_redirects: true).body
      )
    end
  end
end
