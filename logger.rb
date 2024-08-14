# frozen_string_literal: true

# Just wanted to dry logging flow.
# There should/could be real Logger singleton.
class Logger
  def self.info(message)
    puts "[INFO] #{message}"
  end

  def self.error(message)
    warn "[ERROR] #{message}"
  end
end
