# frozen_string_literal: true

require 'date'

require_relative '../smashing_magazine_parser/url_builder'
require_relative '../smashing_magazine_parser/save_images_service'
require_relative '../smashing_magazine_parser/wallpaper_link'
require_relative '../smashing_magazine_parser/wallpaper'
require_relative '../smashing_magazine_parser/wallpapers_builder'
require_relative '../cli/arguments_validator'

require_relative '../logger'

require 'dotenv'
Dotenv.load('.env.test')

require 'webmock/rspec'
