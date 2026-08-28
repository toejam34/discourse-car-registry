# frozen_string_literal: true

module ::CarRegistry
  class CarsController < ::ApplicationController
    requires_plugin ::CarRegistry::PLUGIN_NAME
<<<<<<< HEAD

    skip_before_action :check_xhr, only: %i[index meta]
    before_action :ensure_logged_in, only: %i[create update destroy]
    before_action :ensure_can_add_car, only: :create
=======
    skip_before_action :check_xhr, only: [:index, :meta]
    before_action :ensure_logged_in, only: [:create, :update, :destroy]
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410

    def index
      respond_to do |format|
        format.html { render "default/empty" }
<<<<<<< HEAD
=======

>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
        format.json do
          entries = ::CarRegistry::CarRegistryEntry.includes(:user, :car_model, :car_location)

<<<<<<< HEAD
          if params[:model_id].present? && params[:model_id].to_i.positive?
            entries = entries.where(model_id: params[:model_id].to_i)
=======
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
            total_pages = (total_count.to_f / per_page).ceil
            total_pages = 1 if total_pages < 1

            entries = entries.order(updated_at: :desc).offset((page - 1) * per_page).limit(per_page)

            render json: {
              cars: serialize_data(entries, ::CarRegistry::CarRegistryEntrySerializer),
              meta: {
                total: total_count,
                total_pages: total_pages,
                page: page,
                per_page: per_page
              }
            }
          rescue => e
            Rails.logger.error("CarRegistry Error: #{e.message}\n#{e.backtrace.join("\n")}")
            render json: { error: e.message }, status: 500
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
          end

          if params[:location_id].present? && params[:location_id].to_i.positive?
            entries = entries.where(location_id: params[:location_id].to_i)
          end

          if params[:colour].present?
            entries = entries.where("LOWER(colour) LIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(params[:colour].to_s.downcase)}%")
          end

          if params[:q].present?
            like = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.downcase)}%"
            entries = entries.where(
              "LOWER(username) LIKE :q OR LOWER(reg_number) LIKE :q OR LOWER(plaque_number) LIKE :q OR LOWER(forum_name) LIKE :q OR LOWER(unique_information) LIKE :q",
              q: like
            )
          end

          total_count = entries.count
          page = [params[:page].to_i, 1].max
          per_page = (params[:per_page].presence || 50).to_i.clamp(10, 100)
          total_pages = [(total_count.to_f / per_page).ceil, 1].max
          page = [page, total_pages].min

          entries = entries.order(updated_at: :desc).offset((page - 1) * per_page).limit(per_page)

          render json: {
            cars: serialize_data(entries, ::CarRegistry::CarRegistryEntrySerializer),
            meta: {
              total: total_count,
              total_pages: total_pages,
              page: page,
              per_page: per_page,
              models: serialize_data(::CarRegistry::CarModel.all, ::CarRegistry::CarModelSerializer),
              locations: serialize_data(::CarRegistry::CarLocation.all, ::CarRegistry::CarLocationSerializer),
              colours: ::CarRegistry::CarRegistryEntry.where.not(colour: [nil, ""]).distinct.order(:colour).pluck(:colour)
            }
          }
        end
      end
    end

    def meta
      render json: {
        models: serialize_data(::CarRegistry::CarModel.all, ::CarRegistry::CarModelSerializer),
        locations: serialize_data(::CarRegistry::CarLocation.all, ::CarRegistry::CarLocationSerializer),
        colours: ::CarRegistry::CarRegistryEntry.where.not(colour: [nil, ""]).distinct.order(:colour).pluck(:colour)
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
      raise Discourse::InvalidAccess unless current_user.admin? || entry.user_id == current_user.id

      if entry.update(car_params)
        render_serialized(entry, ::CarRegistry::CarRegistryEntrySerializer)
      else
        render_json_error(entry)
      end
    end

    def destroy
      entry = ::CarRegistry::CarRegistryEntry.find(params[:id])
      raise Discourse::InvalidAccess unless current_user.admin? || entry.user_id == current_user.id

      entry.destroy!
      render json: success_json
    end

    private

    def ensure_can_add_car
      return if current_user.admin? || SiteSetting.car_registry_allow_all_users_to_add

      raise Discourse::InvalidAccess
    end

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
