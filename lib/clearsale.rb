require 'active_support/all'

module Clearsale
  extend ActiveSupport::Autoload

  autoload :Object,        'clearsale/object'
  autoload :Order,         'clearsale/order'
  autoload :OrderResponse, 'clearsale/order_response'
  autoload :Connector,     'clearsale/connector'
  autoload :Analysis,      'clearsale/analysis'
  autoload :LoggerFormatterFilter, 'clearsale/logger_formatter_filter'
end
