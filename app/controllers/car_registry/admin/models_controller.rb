# frozen_string_literal: true

module ::CarRegistry
  module Admin
    class ModelsController < ::Admin::AdminController
      def index
        render_serialized(::CarRegistry::CarModel.all, ::CarRegistry::CarModelSerializer)
      end

      def create
        model = ::CarRegistry::CarModel.new(model_params)
        if model.save
          render_serialized(model, ::CarRegistry::CarModelSerializer)
        else
          render_json_error(model)
        end
      end

      def update
        model = ::CarRegistry::CarModel.find(params[:id])
        if model.update(model_params)
          render_serialized(model, ::CarRegistry::CarModelSerializer)
        else
          render_json_error(model)
        end
      end

      def destroy
        ::CarRegistry::CarModel.find(params[:id]).destroy!
        render json: success_json
      end

      private

      def model_params
        params.require(:model).permit(:name, :position)
      end
    end
  end
end
