# frozen_string_literal: true

class Logger
  def self.info(message)
    puts "[INFO] #{message}"
  end

  def self.error(message)
    warn "[ERROR] #{message}"
  end
end
