require 'spec_helper'
require 'logger'
require 'tempfile'

describe Clearsale::LoggerFormatterFilter do
  let(:tmp_file) { Tempfile.new('tagfilter') }
  let(:logger)   { Logger.new tmp_file }

  let(:order_xml)          { File.read('./spec/fixtures/clearsale.xml').chomp }
  let(:filtered_order_xml) { File.read('./spec/fixtures/filtered_clearsale.xml').chomp }

  after do
    tmp_file.close
  end

  context "Initialize using tags and block" do
    before do
      logger.formatter = described_class.new(%w(CardNumber CardBin)) do |severity, datetime, progname, filtered_msg|
        "#{severity} #{filtered_msg}"
      end
    end

    it "filters the configured tag names using block" do
      logger.info(order_xml)
      tmp_file.rewind
      expect(tmp_file.read).to  eq("INFO #{filtered_order_xml}")
    end
  end

  context "Initialize without block" do
    before do
      logger.formatter = described_class.new(%w(CardNumber CardBin))
    end

    it "filters the configured tag names" do
      logger.info(order_xml)
      tmp_file.rewind
      expect(tmp_file.read.end_with?(filtered_order_xml)).to be(true)
    end
  end

  context "Initialize without tags" do
    before do
      logger.formatter = described_class.new do |severity, datetime, progname, filtered_msg|
        "#{severity} #{filtered_msg}"
      end
    end

    it "filters the configured tag names" do
      logger.info(order_xml)
      tmp_file.rewind
      expect(tmp_file.read).to eq("INFO #{order_xml}")
    end
  end
end

