module Clearsale::LoggerFormatterFilter
  
  mattr_accessor :tags_to_filter

  OPEN_TAG   = lambda{ |tag_name| "&lt;#{tag_name}&gt;"   }
  CLOSE_TAG  = lambda{ |tag_name| "&lt;\/#{tag_name}&gt;" }
  TAG_REGEXP = lambda{ |tag_name, content| "#{OPEN_TAG.call(tag_name)}#{content}#{CLOSE_TAG.call(tag_name)}" }

  def self.filter(msg)
    return msg if !msg.respond_to?(:gsub) || tags_to_filter.nil?

    tags_to_filter.each do |tag|
      msg = msg.gsub(%r{#{TAG_REGEXP.call(tag,'.*')}}, TAG_REGEXP.call(tag,"[FILTERED]")) 
    end
    msg
  end

  def self.new_instance(&block)
    if block_given?
      lambda do |severity, datetime, progname, msg|
        block.call(severity, datetime, progname, filter(msg))
      end
    else
      lambda do |severity, datetime, progname, msg|
        "#{severity} #{datetime} --#{progname}: #{filter(msg)}"
      end
    end
  end
end

