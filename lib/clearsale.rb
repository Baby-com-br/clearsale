require 'active_support/all'

module Clearsale
  extend ActiveSupport::Autoload

  autoload :Analysis,              'clearsale/analysis'
  autoload :Config,                'clearsale/config'
  autoload :Connector,             'clearsale/connector'
  autoload :LoggerFormatterFilter, 'clearsale/logger_formatter_filter'
  autoload :Object,                'clearsale/object'
  autoload :Order,                 'clearsale/order'
  autoload :OrderResponse,         'clearsale/order_response'
end
