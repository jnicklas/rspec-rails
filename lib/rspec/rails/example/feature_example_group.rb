module RSpec::Rails
  module FeatureExampleGroup
    extend ActiveSupport::Concern
    include RSpec::Rails::RailsExampleGroup

    included do
      metadata[:type] = :feature

      include Rails.application.routes_url_helpers
    end

    def visit(*)
      if defined?(super)
        super
      else
        raise "Capybara not loaded, please add it to your Gemfile:\n\ngem \"capybara\""
      end
    end
  end
end
