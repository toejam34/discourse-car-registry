# frozen_string_literal: true

# name: discourse-car-registry
# about: Vehicle and Car Registry directory for Discourse
# version: 1.0.3
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
  require_relative 'app/serializers/car_location_serializer'
  require_relative 'app/serializers/car_model_serializer'
  require_relative 'app/serializers/car_registry_entry_serializer'
  require_relative 'app/controllers/car_registry/cars_controller'
  require_relative 'app/controllers/car_registry/admin/models_controller'
  require_relative 'app/controllers/car_registry/admin/locations_controller'

  Discourse::Application.routes.append do
    get '/cars(.:format)' => 'car_registry/cars#index'
    get '/cars/meta(.:format)' => 'car_registry/cars#meta'
    post '/cars(.:format)' => 'car_registry/cars#create'
    put '/cars/:id(.:format)' => 'car_registry/cars#update'
    delete '/cars/:id(.:format)' => 'car_registry/cars#destroy'

    scope '/admin/cars', as: 'admin_cars' do
      resources :models, controller: 'car_registry/admin/models'
      resources :locations, controller: 'car_registry/admin/locations'
    end
  end

  add_to_serializer(:user_card, :cars_count) do
    ::CarRegistry::CarRegistryEntry.where(user_id: object.id).count
  end
end
