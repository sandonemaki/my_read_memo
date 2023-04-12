module Projects
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: false,
        view_spec: false,
        helper_specs: false,
        routing_specs: false,
        g.factory_bot false
    end
  end
end
