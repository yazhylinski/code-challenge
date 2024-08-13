#!/usr/bin/env ruby
# frozen_string_literal: true

require 'dotenv'
Dotenv.load('.env', '.env.local')

require 'httparty'
require 'nokogiri'

require_relative 'cli/arguments_validator'
require_relative 'cli/invalid_arguments_error'

require_relative 'logger'

require_relative 'smashing_magazine_parser/url_builder'
require_relative 'smashing_magazine_parser/wallpapers_builder'
require_relative 'smashing_magazine_parser/save_images_service'
require_relative 'smashing_magazine_parser/filtering_service'
require_relative 'smashing_magazine_parser/anthropic_cloude/recognize_image_by_theme_strategy'

begin
  arguments = Cli::ArgumentsValidator.new.call
rescue Cli::InvalidArgumentsError => e
  Logger.error(e)
  abort
end

wallpapers_page_url = SmashingMagazineParser::UrlBuilder.new(arguments.date).build

Logger.info("Wallpaper page url: #{wallpapers_page_url}")

html = HTTParty.get(wallpapers_page_url)

if html.body.nil?
  Logger.error('Unable to fetch the page')
  abort
end

html_doc = Nokogiri::HTML(html.body)

Logger.info('HTML is fetched and parsed')

wallpapers = SmashingMagazineParser::WallpapersBuilder.new(html_doc).build
Logger.info("Parsed #{wallpapers.length} wallpapers")

filtered_wallpapers = SmashingMagazineParser::FilteringService.new(
  wallpapers,
  SmashingMagazineParser::AnthropicCloude::RecognizeImageByThemeStrategy.new(arguments.theme)
).call

Logger.info("Found #{filtered_wallpapers.length} wallpapers for current theme")

subdir = "#{arguments.date.year}/#{arguments.date.month}/#{arguments.theme}"

SmashingMagazineParser::SaveImagesService.new(filtered_wallpapers, subdir).call

Logger.info('Finished!')
