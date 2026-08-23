# frozen_string_literal: true

module ::CarRegistry
  class CarModel < ::ActiveRecord::Base
    self.table_name = "car_models"

    has_many :car_registry_entries, class_name: "::CarRegistry::CarRegistryEntry", foreign_key: :model_id, dependent: :nullify

    validates :name, presence: true, uniqueness: true

    default_scope { order(:position, :name) }
  end
end

CarModel = ::CarRegistry::CarModel unless defined?(CarModel)
