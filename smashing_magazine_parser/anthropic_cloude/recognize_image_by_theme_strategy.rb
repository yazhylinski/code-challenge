# frozen_string_literal: true

require 'anthropic'
require 'base64'

require_relative '../../logger'

module SmashingMagazineParser
  module AnthropicCloude
    class RecognizeImageByThemeStrategy
      # @theme String
      def initialize(theme)
        self.theme = theme
        self.client = Anthropic::Client.new(access_token: ENV.fetch('ANTHROPIC_CLOUDE_API_KEY'))
      end

      # @extension String
      # @image [String] File value
      def match_theme?(extension, image)
        # For some reasons this API fails with jpg
        extension = 'jpeg' if extension == 'jpg'

        imgbase64 = Base64.strict_encode64(image)

        response = client.messages(**request_body(imgbase64, extension))

        # Here good place to validate the response
        # and in case of invalid => retry
        response['content'][0]['text'].downcase['yes']
      rescue StandardError
        raise UnableToRecognizeImageError, 'Unable to recognize image. Skipping'
      end

      private

      attr_accessor :theme, :client

      # rubocop:disable Metrics/MethodLength
      def request_body(imgbase64, extension)
        {
          parameters: {
            model: 'claude-3-haiku-20240307', # claude-3-opus-20240229, claude-3-sonnet-20240229
            system: 'Respond only in English.',
            messages: [
              {
                role: 'user',
                content: [
                  {
                    type: 'image',
                    source: {
                      type: 'base64',
                      media_type: "image/#{extension}",
                      data: imgbase64
                    }
                  },
                  {
                    type: 'text',
                    text: 'Answer strictly either YES or NO. Your answer is one word. ' \
                          "Does this image match theme \"#{theme}\""
                  }
                ]
              }
            ],
            max_tokens: 10
          }
        }
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
