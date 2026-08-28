# frozen_string_literal: true

module ::CarRegistry
  class CarModelSerializer < ::ApplicationSerializer
    attributes :id, :name, :position
  end
end
