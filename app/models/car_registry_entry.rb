# frozen_string_literal: true

module ::CarRegistry
  class CarRegistryEntry < ::ActiveRecord::Base
    self.table_name = "car_registry_entries"

    belongs_to :user, class_name: "::User", optional: true
    belongs_to :car_model, class_name: "::CarRegistry::CarModel", foreign_key: :model_id, optional: true
    belongs_to :car_location, class_name: "::CarRegistry::CarLocation", foreign_key: :location_id, optional: true

    validates :username, presence: true

    before_save :sync_username_from_user

    def sync_username_from_user
      self.username = user.username if user.present?
    end
  end
end

CarRegistryEntry = ::CarRegistry::CarRegistryEntry unless defined?(CarRegistryEntry)
