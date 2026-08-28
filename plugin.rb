# frozen_string_literal: true

# name: discourse-car-registry
# about: A native vehicle and car registry directory for TurboRenault
# version: 0.2.0
# authors: Andy
# url: https://github.com/toejam34/discourse-car-registry

enabled_site_setting :car_registry_enabled

register_asset "stylesheets/car-registry.scss"

module ::CarRegistry
  PLUGIN_NAME = "discourse-car-registry"
end

Discourse::Application.routes.append do
  get "/cars" => "car_registry/cars#index"
  get "/cars/meta" => "car_registry/cars#meta"
  post "/cars" => "car_registry/cars#create"
  put "/cars/:id" => "car_registry/cars#update"
  delete "/cars/:id" => "car_registry/cars#destroy"

  namespace :admin, constraints: StaffConstraint.new do
    resources :car_models,
      only: %i[index create update destroy],
      controller: "car_registry/admin/models"
    resources :car_locations,
      only: %i[index create update destroy],
      controller: "car_registry/admin/locations"
  end
end

after_initialize do
  require_relative "app/models/car_model"
  require_relative "app/models/car_location"
  require_relative "app/models/car_registry_entry"
  require_relative "app/serializers/car_model_serializer"
  require_relative "app/serializers/car_location_serializer"
  require_relative "app/serializers/car_registry_entry_serializer"
  require_relative "app/controllers/car_registry/cars_controller"
  require_relative "app/controllers/car_registry/admin/models_controller"
  require_relative "app/controllers/car_registry/admin/locations_controller"
end
