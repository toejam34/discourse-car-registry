# frozen_string_literal: true

module ::CarRegistry
  class CarsController < ::ApplicationController
    requires_plugin ::CarRegistry::PLUGIN_NAME

    skip_before_action :check_xhr, only: %i[index meta]
    before_action :ensure_car_registry_enabled
    before_action :ensure_logged_in, only: %i[create update destroy]
    before_action :ensure_user_can_add, only: :create

    def index
      respond_to do |format|
        format.html { render "default/empty" }
        format.json do
          entries = ::CarRegistry::CarRegistryEntry.includes(:user, :car_model, :car_location)
          entries = apply_filters(entries)

          total_count = entries.count
          per_page = (params[:per_page].presence || 50).to_i.clamp(10, 100)
          total_pages = [(total_count.to_f / per_page).ceil, 1].max
          page = [params[:page].to_i, 1].max
          page = total_pages if page > total_pages

          entries = entries.order(updated_at: :desc)
                           .offset((page - 1) * per_page)
                           .limit(per_page)

          render json: {
            cars: serialize_data(entries, ::CarRegistry::CarRegistryEntrySerializer),
            meta: {
              total: total_count,
              total_pages: total_pages,
              page: page,
              per_page: per_page,
            },
          }
        end
      end
    end

    def meta
      render json: {
        models: serialize_data(::CarRegistry::CarModel.all, ::CarRegistry::CarModelSerializer),
        locations: serialize_data(::CarRegistry::CarLocation.all, ::CarRegistry::CarLocationSerializer),
        colours: ::CarRegistry::CarRegistryEntry.where.not(colour: [nil, ""]).distinct.order(:colour).pluck(:colour),
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
      raise Discourse::InvalidAccess unless can_edit?(entry)

      if entry.update(car_params)
        render_serialized(entry, ::CarRegistry::CarRegistryEntrySerializer)
      else
        render_json_error(entry)
      end
    end

    def destroy
      entry = ::CarRegistry::CarRegistryEntry.find(params[:id])
      raise Discourse::InvalidAccess unless can_edit?(entry)

      entry.destroy!
      render json: success_json
    end

    private

    def ensure_car_registry_enabled
      raise Discourse::NotFound unless SiteSetting.car_registry_enabled
    end

    def ensure_user_can_add
      return if SiteSetting.car_registry_allow_all_users_to_add || current_user.admin?

      raise Discourse::InvalidAccess
    end

    def can_edit?(entry)
      current_user.admin? || entry.user_id == current_user.id
    end

    def apply_filters(relation)
      if params[:model_id].present? && params[:model_id] != "0"
        relation = relation.where(model_id: params[:model_id].to_i)
      end

      if params[:location_id].present? && params[:location_id] != "0"
        relation = relation.where(location_id: params[:location_id].to_i)
      end

      if params[:colour].present?
        colour = "%#{::ActiveRecord::Base.sanitize_sql_like(params[:colour].to_s.downcase)}%"
        relation = relation.where("LOWER(colour) LIKE ?", colour)
      end

      if params[:q].present?
        query = "%#{::ActiveRecord::Base.sanitize_sql_like(params[:q].to_s.downcase)}%"
        relation = relation.where(
          "LOWER(username) LIKE :q OR LOWER(reg_number) LIKE :q OR LOWER(plaque_number) LIKE :q OR LOWER(forum_name) LIKE :q OR LOWER(unique_information) LIKE :q",
          q: query,
        )
      end

      relation
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
        :unique_information,
      )
    end
  end
end
