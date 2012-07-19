require 'spec_helper'

module Clearsale
  describe Object do
    describe "behavior it inherits from OpenStruct" do
      it "can represent arbitrary data objects" do
        ros = Object.new
        ros.blah = "John Smith"
        ros.blah.should == "John Smith"
      end

      it "can be created from a hash" do
        h = { :asdf => 'John Smith' }
        ros = Object.new(h)
        ros.asdf.should == "John Smith"
      end

      it "can modify an existing key" do
        h = { :blah => 'John Smith' }
        ros = Object.new(h)
        ros.blah = "George Washington"
        ros.blah.should == "George Washington"
      end

      describe "handling of arbitrary attributes" do
        before(:each) do
          @object = Object.new
          @object.blah = "John Smith"
        end

        describe "#respond?" do
          it { @object.should respond_to :blah }
          it { @object.should respond_to :blah= }
          it { @object.should_not respond_to :asdf }
          it { @object.should_not respond_to :asdf= }
        end

        describe "#methods" do
          it { @object.methods.should include :blah }
          it { @object.methods.should include :blah= }
          it { @object.methods.should_not include :asdf }
          it { @object.methods.should_not include :asdf= }
        end
      end
    end

    describe "recursive behavior" do
      before(:each) do
        h = { :blah => { :another => 'value'}, :list => [ { :foo => :bar } ] }
        @object = Object.new(h)
      end

      it "returns accessed hashes as Objects instead of hashes" do
        @object.blah.another.should == 'value'
      end

      it "uses #key_as_a_hash to return key as a Hash" do
        @object.blah_as_a_hash.should == { :another => 'value' }
      end

      it "return access hash as Object instead of hash even if it is inside a list" do
        @object.list.first.foo.should == :bar
      end

      describe "handling loops in the origin Hashes" do
        before(:each) do
          h1 = { :a => 'a'}
          h2 = { :a => 'b', :h1 => h1 }
          h1[:h2] = h2
          @object = Object.new(h2)
        end

        it { @object.h1.a.should == 'a' }
        it { @object.h1.h2.a.should == 'b' }
        it { @object.h1.h2.h1.a.should == 'a' }
        it { @object.h1.h2.h1.h2.a.should == 'b' }
        it { @object.h1.should == @object.h1.h2.h1 }
        it { @object.h1.should_not == @object.h1.h2 }
      end
    end
  end
end
