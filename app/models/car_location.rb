# frozen_string_literal: true

class CarLocation < ActiveRecord::Base
  self.table_name = 'car_locations'

  has_many :car_registry_entries, foreign_key: :location_id, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  default_scope { order(:position, :name) }
end
