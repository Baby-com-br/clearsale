require 'spec_helper'

module Clearsale
  describe OrderResponse do
    describe "#approved?" do
      let(:response) { {:orders=>{:order=>{:id=>"TS1234", :score=>"21.1100"}}} }

      %w(APA APM).each do |status|
        it "returns true if status is: #{status}" do
          response[:orders][:order][:status] = status
          OrderResponse.new(response).should be_approved
        end
      end
    end

    describe "#rejected?" do
      let(:response) { {:orders=>{:order=>{:id=>"TS1234", :score=>"21.1100"}}} }

      %w(RPM SUS CAN).each do |status|
        it "returns true if status is: #{status}" do
          response[:orders][:order][:status] = status
          OrderResponse.new(response).should be_rejected
        end
      end
    end

    describe "#fraud?" do
      let(:response) { {:orders=>{:order=>{:id=>"TS1234", :score=>"21.1100", :status => "FRD"}}} }

      it "returns true if status is fraud" do
        OrderResponse.new(response).should be_fraud
      end
    end
  end
end
