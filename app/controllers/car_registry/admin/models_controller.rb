# frozen_string_literal: true

module CarRegistry
  module Admin
    class ModelsController < ::Admin::AdminController
      def index
        render_serialized(CarModel.all, CarModelSerializer)
      end

      def create
        model = CarModel.new(model_params)
        if model.save
          render_serialized(model, CarModelSerializer)
        else
          render_json_error(model)
        end
      end

      def update
        model = CarModel.find(params[:id])
        if model.update(model_params)
          render_serialized(model, CarModelSerializer)
        else
          render_json_error(model)
        end
      end

      def destroy
        model = CarModel.find(params[:id])
        model.destroy!
        render json: success_json
      end

      private

      def model_params
        params.require(:model).permit(:name, :position)
      end
    end
  end
end
