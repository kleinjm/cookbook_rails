# frozen_string_literal: true

require "open-uri"

def internet_connection?
  true if open("http://www.google.com/")
rescue SocketError
  Rails.logger.error("Internet connection unavailable")
  false
end
