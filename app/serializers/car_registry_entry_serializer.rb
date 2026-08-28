# frozen_string_literal: true

module ::CarRegistry
  class CarRegistryEntrySerializer < ::ApplicationSerializer
    attributes :id,
               :user_id,
               :username,
               :avatar_url,
               :model_id,
               :model_name,
               :location_id,
               :location_name,
               :colour,
               :trim,
               :plaque_number,
               :reg_number,
               :car_reg_date,
               :car_reg_date_formatted,
               :forum_name,
               :unique_information,
               :created_at,
               :updated_at,
               :can_edit

    def avatar_url
      template = object.user&.avatar_template
      return nil if template.blank?

      template.sub("{size}", "45")
    end

    def model_name
      object.car_model&.name
    end

    def location_name
      object.car_location&.name
    end

    def car_reg_date_formatted
      object.car_reg_date&.strftime("%d/%m/%Y")
    end

    def can_edit
      return false unless scope&.user

      scope.user.admin? || (object.user_id.present? && object.user_id == scope.user.id)
    end
  end
end

CarRegistryEntrySerializer = ::CarRegistry::CarRegistryEntrySerializer unless defined?(CarRegistryEntrySerializer)
