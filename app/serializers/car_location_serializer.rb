# frozen_string_literal: true

module ::CarRegistry
  class CarLocationSerializer < ::ApplicationSerializer
    attributes :id, :name, :position
  end
end
