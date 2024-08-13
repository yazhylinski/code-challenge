# frozen_string_literal: true

require 'date'
require 'optparse'
require_relative 'invalid_arguments_error'
require_relative 'arguments'

module Cli
  class ArgumentsValidator
    def call
      begin
        options = validate_arguments
      rescue OptionParser::InvalidOption => e
        raise InvalidArgumentsError, e
      end

      validate_required_params(options)

      date = Date.new(options[:month][2..5].to_i, options[:month][0..1].to_i)

      Cli::Arguments.new(date, options[:theme])
    end

    private

    def validate_arguments
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: ./smashing.rb --month mmyyyy --theme STRING'

        opts.on('--month=MMYYYY', '6-digits in format mmyyyy') do |v|
          options[:month] = v
        end

        opts.on('--theme=STRING') do |v|
          options[:theme] = v
        end
      end

      parser.parse!

      options
    end

    def validate_required_params(options)
      raise InvalidArgumentsError, 'Month argument is required and must have 6 digits' unless options[:month]

      raise InvalidArgumentsError, 'Month argument is invalid and must have 6 digits' if options[:month].length != 6

      raise InvalidArgumentsError, 'Theme argument is required' unless options[:theme]
    end
  end
end
