# encoding: utf-8
require 'spec_helper'
require 'clearsale'

describe 'Risk Analysis with ClearSale' do
  describe 'sending orders' do
    it "returns the package response" do
      VCR.use_cassette('clearsale_send_orders') do
        response = Clearsale::Analysis.send_order(order, payment, user)

        response.should be_manual_analysis
        response.score.should be_within(0.01).of(21.11)
        response.order_id.should eq(1234)
      end
    end
  end

  describe "updating order status" do
    context "existing order" do
      it "returns the package response" do
        VCR.use_cassette('clearsale_get_order_status') do
          response = Clearsale::Analysis.get_order_status('1234')
          response.should be_manual_analysis
          response.score.should be_within(0.01).of(21.11)
          response.order_id.should eq(1234)
        end
      end
    end

    context "missing order" do
      it "returns the package response" do
        VCR.use_cassette('clearsale_get_order_status_missing') do
          order = double('Order', :id => 1234567890)

          response = Clearsale::Analysis.get_order_status(order)
          response.should be_inexistent_order
        end
      end
    end
  end

  require 'webmock/rspec'

  describe "setting the environment" do
    context "when CLEARSALE_ENV is production" do
      it "should access production url" do
        VCR.use_cassette('clearsale_get_order_status_production') do
          Clearsale::Analysis.clear_connector
          ENV["CLEARSALE_ENV"] = 'production'
          Clearsale::Analysis.get_order_status('1234')

          a_request(:post, "https://www.clearsale.com.br/integracaov2/service.asmx").should have_been_made
        end
      end
    end

    context "when CLEARSALE_ENV isn't production" do
      it "should access production url" do
        VCR.use_cassette('clearsale_get_order_status') do
          Clearsale::Analysis.clear_connector
          ENV["CLEARSALE_ENV"] = 'any'
          Clearsale::Analysis.get_order_status('1234')

          a_request(:post, "http://homologacao.clearsale.com.br/Integracaov2/Service.asmx").should have_been_made
        end
      end
    end
  end
end
