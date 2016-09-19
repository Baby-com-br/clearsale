require 'spec_helper'

module Clearsale
  describe Object do
    describe "behavior it inherits from OpenStruct" do
      it "can represent arbitrary data objects" do
        ros = Object.parse({})
        ros.blah = "John Smith"
        expect(ros.blah).to eq("John Smith")
      end

      it "can be created from a hash" do
        h = { :asdf => 'John Smith' }
        ros = Object.parse(h)
        expect(ros.asdf).to eq("John Smith")
      end

      it "can modify an existing key" do
        h = { :blah => 'John Smith' }
        ros = Object.parse(h)
        ros.blah = "George Washington"
        expect(ros.blah).to eq("George Washington")
      end

      describe "handling of arbitrary attributes" do
        before(:each) do
          @object = Object.parse({})
          @object.blah = "John Smith"
        end

        describe "#respond?" do
          it { expect(@object).to respond_to :blah }
          it { expect(@object).to respond_to :blah= }
          it { expect(@object).to_not respond_to :asdf }
          it { expect(@object).to_not respond_to :asdf= }
        end

        describe "#methods" do
          it { expect(@object.methods).to include :blah }
          it { expect(@object.methods).to include :blah= }
          it { expect(@object.methods).to_not include :asdf }
          it { expect(@object.methods).to_not include :asdf= }
        end
      end
    end

    describe "recursive behavior" do
      before(:each) do
        h = { :blah => { :another => 'value'}, :list => [ { :foo => 'bar' } ] }
        @object = Object.parse(h)
      end

      it "returns accessed hashes as Objects instead of hashes" do
        expect(@object.blah.another).to eq('value')
      end

      it "return access hash as Object instead of hash even if it is inside a list" do
        expect(@object.list.first.foo).to eq('bar')
      end
    end
  end
end
