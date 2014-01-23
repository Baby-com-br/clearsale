require 'savon'
require 'nori'

module Clearsale
  class Config
    cattr_accessor :logger, :log

    def self.logger
      @@logger ||= Logger.new(STDOUT)
    end

    def self.log
      @@log.nil? ? true : @@log
    end
  end
end
