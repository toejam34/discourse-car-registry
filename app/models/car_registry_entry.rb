# frozen_string_literal: true

class CarRegistryEntry < ActiveRecord::Base
  self.table_name = 'car_registry_entries'

  belongs_to :user, optional: true
  belongs_to :car_model, foreign_key: :model_id, optional: true
  belongs_to :car_location, foreign_key: :location_id, optional: true

  validates :username, presence: true

  before_save :sync_username_from_user

  def sync_username_from_user
    self.username = user.username if user.present?
  end
end
