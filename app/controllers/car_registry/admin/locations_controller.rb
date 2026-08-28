# frozen_string_literal: true

module ::CarRegistry
  module Admin
    class LocationsController < ::Admin::AdminController
      def index
        render_serialized(::CarRegistry::CarLocation.all, ::CarRegistry::CarLocationSerializer)
      end

      def create
        location = ::CarRegistry::CarLocation.new(location_params)
        if location.save
          render_serialized(location, ::CarRegistry::CarLocationSerializer)
        else
          render_json_error(location)
        end
      end

      def update
        location = ::CarRegistry::CarLocation.find(params[:id])
        if location.update(location_params)
          render_serialized(location, ::CarRegistry::CarLocationSerializer)
        else
          render_json_error(location)
        end
      end

      def destroy
        ::CarRegistry::CarLocation.find(params[:id]).destroy!
        render json: success_json
      end

      private

      def location_params
        params.require(:location).permit(:name, :position)
      end
    end
  end
end
