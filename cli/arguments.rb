# frozen_string_literal: true

module Cli
  class Arguments
    attr_reader :date, :theme

    def initialize(date, theme)
      self.date = date
      self.theme = theme
    end

    private

    attr_writer :date, :theme
  end
end
