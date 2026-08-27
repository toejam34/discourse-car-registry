# frozen_string_literal: true

# name: discourse-car-registry
# about: Vehicle and Car Registry directory for TurboRenault Discourse
# version: 1.0.2
# authors: TurboRenault / Antigravity
# url: https://github.com/toejam34/discourse-car-registry
# required_version: 2.7.0

enabled_site_setting :car_registry_enabled

register_asset 'stylesheets/car-registry.scss'
register_svg_icon 'car' if respond_to?(:register_svg_icon)

after_initialize do
  module ::CarRegistry
    PLUGIN_NAME = 'discourse-car-registry'

    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace CarRegistry
    end
  end

  require_relative 'app/models/car_model'
  require_relative 'app/models/car_location'
  require_relative 'app/models/car_registry_entry'
  require_relative 'app/serializers/car_registry_entry_serializer'
  require_relative 'app/controllers/car_registry/cars_controller'
  require_relative 'app/controllers/car_registry/admin/models_controller'
  require_relative 'app/controllers/car_registry/admin/locations_controller'

  CarRegistry::Engine.routes.draw do
    get '/' => 'cars#index'
    get '/meta' => 'cars#meta'
    post '/' => 'cars#create'
    put '/:id' => 'cars#update'
    delete '/:id' => 'cars#destroy'

    scope '/admin', as: 'admin' do
      resources :models, only: [:index, :create, :update, :destroy]
      resources :locations, only: [:index, :create, :update, :destroy]
    end
  end

  Discourse::Application.routes.prepend do
    mount ::CarRegistry::Engine, at: '/cars'
  end

  add_to_serializer(:user_card, :cars_count) do
    ::CarRegistry::CarRegistryEntry.where(user_id: object.id).count
  end
end
