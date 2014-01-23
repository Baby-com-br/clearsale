class Clearsale::LoggerFormatterFilter
  OPEN_TAG   = lambda{ |tag_name| "&lt;#{tag_name}&gt;"   }
  CLOSE_TAG  = lambda{ |tag_name| "&lt;\/#{tag_name}&gt;" }
  TAG_REGEXP = lambda{ |tag_name, content| "#{OPEN_TAG.call(tag_name)}#{content}#{CLOSE_TAG.call(tag_name)}" }

  def filter(msg)
    return msg if !msg.respond_to?(:gsub) || @tags_to_filter.nil?

    @tags_to_filter.each do |tag|
      msg = msg.gsub(%r{#{TAG_REGEXP.call(tag,'.*')}}, TAG_REGEXP.call(tag,"[FILTERED]"))
    end
    msg
  end

  def initialize(tags_to_filter = [], &block)
    @tags_to_filter = tags_to_filter
    @block = block
  end

  def call(severity, datetime, progname, msg)
    if @block
      @block.call(severity, datetime, progname, filter(msg))
    else
      "#{severity} #{datetime} --#{progname}: #{filter(msg)}"
    end
  end
end

