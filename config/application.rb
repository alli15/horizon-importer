require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

Dotenv::Railtie.load

module Horizon
  class Application < Rails::Application


    require "#{config.root}/lib/request_metrics"
    config.middleware.insert_before ActionDispatch::ShowExceptions,
      RequestMetrics, Metriks::Registry.default

    require "#{config.root}/lib/problem_renderer"
    config.exceptions_app = ProblemRenderer

    # custom configs

    config.stellard_url = ENV["STELLARD_URL"]
    raise "STELLARD_URL environment variable unset" if config.stellard_url.blank?
    #

    if ENV["CACHE_URL"].present?
      servers = ENV["CACHE_URL"].split(",")
      config.cache_store = Memcached::Rails.new(servers)
    else
      config.cache_store = :memory_store
    end

    config.autoload_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/app/errors"
    config.autoload_paths << "#{config.root}/app/serializers"

    config.generators do |g|
      g.orm             :active_record
      g.test_framework  :rspec, fixture: false, views: false
      g.template_engine false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

    config.active_record.schema_format = :sql

  end
end
