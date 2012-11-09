require "spec_helper"

module RSpec::Rails
  describe FeatureExampleGroup do
    it { should be_included_in_files_in('./spec/features/') }
    it { should be_included_in_files_in('.\\spec\\features\\') }

    it "adds :type => :model to the metadata" do
      group = RSpec::Core::ExampleGroup.describe do
        include FeatureExampleGroup
      end
      group.metadata[:type].should eq(:feature)
    end

    it "includes Rails route helpers" do
      Rails.application.routes.draw do
        match "/foo", :as => :foo, :to => "foo#bar"
      end

      group = RSpec::Core::ExampleGroup.describe do
        include FeatureExampleGroup
      end
      group.new.foo_path.should == "/foo"
    end

    describe "#visit" do
      it "raises an error informing about missing Capybara" do
        group = RSpec::Core::ExampleGroup.describe do
          include FeatureExampleGroup
        end
        expect do
          group.new.visit('/foobar')
        end.to raise_error(/Capybara not loaded/)
      end

      it "is resistant to load order errors" do
        capybara = Module.new do
          def visit(url)
            "success: #{url}"
          end
        end
        group = RSpec::Core::ExampleGroup.describe do
          include capybara
          include FeatureExampleGroup
        end
        group.new.visit("/foo").should == "success: /foo"
      end
    end
  end
end
