# frozen_string_literal: true

module CarRegistry
  module Admin
    class LocationsController < ::Admin::AdminController
      def index
        render_serialized(CarLocation.all, CarLocationSerializer)
      end

      def create
        loc = CarLocation.new(location_params)
        if loc.save
          render_serialized(loc, CarLocationSerializer)
        else
          render_json_error(loc)
        end
      end

      def update
        loc = CarLocation.find(params[:id])
        if loc.update(location_params)
          render_serialized(loc, CarLocationSerializer)
        else
          render_json_error(loc)
        end
      end

      def destroy
        loc = CarLocation.find(params[:id])
        loc.destroy!
        render json: success_json
      end

      private

      def location_params
        params.require(:location).permit(:name, :position)
      end
    end
  end
end
