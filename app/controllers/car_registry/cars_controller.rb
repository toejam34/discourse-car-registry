# frozen_string_literal: true

module ::CarRegistry
  class CarsController < ::ApplicationController
    requires_plugin ::CarRegistry::PLUGIN_NAME
    skip_before_action :check_xhr, only: [:index]
    before_action :ensure_logged_in, only: [:create, :update, :destroy]

    def index
      respond_to do |format|
        format.html do
          render html: "", layout: "application"
        end

        format.json do
          begin
            entries = ::CarRegistry::CarRegistryEntry.includes(:user, :car_model, :car_location)

            if params[:model_id].present? && params[:model_id] != "0"
              entries = entries.where(model_id: params[:model_id].to_i)
            end

            if params[:location_id].present? && params[:location_id] != "0"
              entries = entries.where(location_id: params[:location_id].to_i)
            end

            if params[:colour].present?
              entries = entries.where("LOWER(colour) LIKE ?", "%#{params[:colour].downcase}%")
            end

            if params[:q].present?
              query = "%#{params[:q].downcase}%"
              entries = entries.where(
                "LOWER(username) LIKE :q OR LOWER(reg_number) LIKE :q OR LOWER(plaque_number) LIKE :q OR LOWER(forum_name) LIKE :q OR LOWER(unique_information) LIKE :q",
                q: query
              )
            end

            total_count = entries.count
            page = [params[:page].to_i, 1].max
            per_page = (params[:per_page].presence || 50).to_i.clamp(10, 100)

            entries = entries.order(updated_at: :desc).offset((page - 1) * per_page).limit(per_page)

            render json: {
              cars: serialize_data(entries, ::CarRegistry::CarRegistryEntrySerializer),
              meta: {
                total: total_count,
                page: page,
                per_page: per_page
              }
            }
          rescue => e
            Rails.logger.error("CarRegistry Error: #{e.message}
#{e.backtrace.join("
")}")
            render json: { error: e.message }, status: 500
          end
        end
      end
    end

    def meta
      models = ::CarRegistry::CarModel.all
      locations = ::CarRegistry::CarLocation.all
      colours = ::CarRegistry::CarRegistryEntry.where.not(colour: [nil, ""]).pluck(:colour).uniq.compact.sort

      render json: {
        models: serialize_data(models, ::CarRegistry::CarModelSerializer),
        locations: serialize_data(locations, ::CarRegistry::CarLocationSerializer),
        colours: colours
      }
    end

    def create
      entry = ::CarRegistry::CarRegistryEntry.new(car_params)
      entry.user = current_user
      entry.username = current_user.username

      if entry.save
        render_serialized(entry, ::CarRegistry::CarRegistryEntrySerializer)
      else
        render_json_error(entry)
      end
    end

    def update
      entry = ::CarRegistry::CarRegistryEntry.find(params[:id])
      raise Discourse::InvalidAccess unless current_user&.admin? || (entry.user_id == current_user.id)

      if entry.update(car_params)
        render_serialized(entry, ::CarRegistry::CarRegistryEntrySerializer)
      else
        render_json_error(entry)
      end
    end

    def destroy
      entry = ::CarRegistry::CarRegistryEntry.find(params[:id])
      raise Discourse::InvalidAccess unless current_user&.admin? || (entry.user_id == current_user.id)

      entry.destroy!
      render json: success_json
    end

    private

    def car_params
      params.require(:car).permit(
        :model_id,
        :location_id,
        :colour,
        :trim,
        :plaque_number,
        :reg_number,
        :car_reg_date,
        :forum_name,
        :unique_information
      )
    end
  end
end
