# frozen_string_literal: true

require_relative 'wallpaper_link'
require_relative 'wallpaper'

module SmashingMagazineParser
  class WallpapersBuilder
    attr_reader :wallpapers

    # @html_doc [Nokogiri::HTML]
    def initialize(html_doc)
      self.html_doc = html_doc

      self.wallpapers = []
    end

    def build
      # The page with wallpapers for some
      # headers have different ids for images.
      # The easisest way is just to iterate throught all
      # tags and add one by one.
      html_doc.css('h2, ul li a').each do |tag|
        parse_tag(tag)
      end

      wallpapers
    end

    private

    def parse_tag(tag)
      # H2 tags is used for wallapaper name
      if tag.name == 'h2'
        wallpapers << Wallpaper.new(tag.children[0].text)
      else
        # This branch is used for links
        url = tag.attribute_nodes.find { _1.name == 'href' }.value

        # To skip other anchors checking the url.
        # If it's not matched it's not wallpaper image.
        # not wallpaper
        return unless url['smashingmagazine.com/files/wallpapers/']

        parse_wallpaper_image(tag, url)
      end
    end

    def parse_wallpaper_image(tag, url)
      # There is one preview image and i decided to track it.
      preview = false

      size = tag.children[0].text

      if size == 'preview'
        size = nil
        preview = true
      end

      with_calendar = !tag.parent.text['with calendar'].nil?

      # It's an image with calendar and without size which is shown by default
      # and it has calendar
      if size == ''
        size = nil
        with_calendar = true
      end

      # Previews have calendar
      with_calendar = true if preview

      wallpapers[-1].links << WallpaperLink.new(url, size, preview, with_calendar)
    end

    attr_accessor :html_doc
    attr_writer :wallpapers
  end
end
