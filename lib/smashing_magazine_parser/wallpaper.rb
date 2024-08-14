# frozen_string_literal: true

module SmashingMagazineParser
  class Wallpaper
    attr_reader :name, :links

    def initialize(name)
      self.name = name
      self.links = []
    end

    private

    attr_writer :name, :links
  end
end
