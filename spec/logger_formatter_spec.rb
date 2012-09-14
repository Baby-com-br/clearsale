require 'spec_helper'
require 'logger'
require 'tempfile'

describe Clearsale::LoggerFormatterFilter do
  let(:tmp_file) { Tempfile.new('tagfilter') }
  let(:logger)   { Logger.new tmp_file }

  let(:order_xml)          { File.read('./spec/fixtures/clearsale.xml').chomp }
  let(:filtered_order_xml) { File.read('./spec/fixtures/filtered_clearsale.xml').chomp }

  before do
    described_class.tags_to_filter = %w(CardNumber CardBin)
    logger.formatter = described_class.new_instance do |severity, datetime, progname, filtered_msg|
      "#{severity} #{filtered_msg}"
    end
  end

  after do
    tmp_file.close
  end

  it "filters the configured tag names" do
    logger.info(order_xml)
    tmp_file.rewind
    tmp_file.read.should == "INFO #{filtered_order_xml}"
  end
end

