import Route from "@ember/routing/route";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import DButton from "discourse/components/d-button";
import avatar from "discourse/helpers/avatar";
import i18n from "discourse/helpers/i18n";
import { eq, or } from "truth-helpers";

class CarsComponentController {
  @tracked searchTerm = "";
  @service router;

  @action
  onSearch(event) {
    this.searchTerm = event.target.value;
    debounce(this, this.performSearch, 400);
  }

  performSearch() {
    this.router.transitionTo({
      queryParams: {
        searchTerm: this.searchTerm,
        page: 1
      }
    });
  }
}

<template>
  <div class="car-registry-container wrap">
    <div class="car-registry-header">
      <h1>{{i18n "car_registry.title"}}</h1>
      <div class="car-registry-actions">
        {{#if @model.currentUser}}
          <DButton
            @label="car_registry.register_button"
            @icon="plus"
            @action={{@model.openRegisterModal}}
            class="btn-primary"
          />
        {{/if}}
      </div>
    </div>

    <div class="car-registry-filters">
      <div class="filter-input">
        <input
          type="text"
          value={{@model.filterParams.searchTerm}}
          placeholder={{i18n "car_registry.filters.search_placeholder"}}
          {{on "input" this.onSearch}}
          class="form-control"
        />
      </div>

      <select {{on "change" @model.onModelChange}} class="form-control">
        <option value="0">{{i18n "car_registry.filters.all_models"}}</option>
        {{#each @model.meta.models as |carModel|}}
          <option value={{carModel.id}} selected={{eq @model.selectedModelId carModel.id}}>
            {{carModel.name}}
          </option>
        {{/each}}
      </select>

      <select {{on "change" @model.onLocationChange}} class="form-control">
        <option value="0">{{i18n "car_registry.filters.all_locations"}}</option>
        {{#each @model.meta.locations as |loc|}}
          <option value={{loc.id}} selected={{eq @model.selectedLocationId loc.id}}>
            {{loc.name}}
          </option>
        {{/each}}
      </select>

      <DButton
        @label="car_registry.filters.reset"
        @icon="sync"
        @action={{@model.resetFilters}}
        class="btn-default"
      />
    </div>

    <div class="car-registry-table-wrapper">
      <table class="car-registry-table">
        <thead>
          <tr>
            <th>{{i18n "car_registry.columns.user"}}</th>
            <th>{{i18n "car_registry.columns.model"}}</th>
            <th>{{i18n "car_registry.columns.colour"}}</th>
            <th>{{i18n "car_registry.columns.trim"}}</th>
            <th>{{i18n "car_registry.columns.location"}}</th>
            <th>{{i18n "car_registry.columns.plaque"}}</th>
            <th>{{i18n "car_registry.columns.reg_number"}}</th>
            <th>{{i18n "car_registry.columns.reg_date"}}</th>
            <th>{{i18n "car_registry.columns.forum_name"}}</th>
            <th>{{i18n "car_registry.columns.unique_info"}}</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          {{#each @model.cars as |car|}}
            <tr>
              <td class="member-col">
                {{#if car.avatar_template}}
                  <a href="/u/{{car.username}}">
                    {{avatar car imageSize="small"}}
                    <span>{{car.username}}</span>
                  </a>
                {{else if car.username}}
                  <span>{{car.username}}</span>
                {{else}}
                  <span>unknown</span>
                {{/if}}
              </td>
              <td><strong>{{car.model_name}}</strong></td>
              <td>{{car.colour}}</td>
              <td>{{car.trim}}</td>
              <td>{{car.location_name}}</td>
              <td class="plaque-col">{{car.plaque_number}}</td>
              <td>
                {{#if car.reg_number}}
                  <span class="reg-col">{{car.reg_number}}</span>
                {{/if}}
              </td>
              <td>{{car.car_reg_date_formatted}}</td>
              <td>{{car.forum_name}}</td>
              <td class="notes-col" title={{car.unique_information}}>
                {{car.unique_information}}
              </td>
              <td>
                {{#if car.can_edit}}
                  <DButton
                    @icon="pencil-alt"
                    @action={{fn @model.openEditModal car}}
                    class="btn-default btn-small"
                  />
                {{/if}}
              </td>
            </tr>
          {{else}}
            <tr>
              <td colspan="11" class="car-registry-empty">
                <p>No vehicles found matching your criteria.</p>
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>

    <div class="car-registry-pagination">
      <DButton
        @icon="chevron-left"
        @action={{@model.previousPage}}
        @disabled={{eq (or @model.page 1) 1}}
        class="btn-default"
      />

      <span class="page-indicator">
        Page {{or @model.page 1}} of {{@model.totalPages}}
      </span>

      <DButton
        @icon="chevron-right"
        @action={{@model.nextPage}}
        @disabled={{@model.isLastPage}}
        class="btn-default"
      />
    </div>
  </div>
</template>

export default class CarsRoute extends Route {
  @service store;

  queryParams = {
    searchTerm: { refreshModel: true },
    selectedModelId: { refreshModel: true },
    selectedLocationId: { refreshModel: true },
    page: { refreshModel: true }
  };

  async model(params) {
    const result = await this.store.query("car-registry-item", params);
    return {
      cars: result,
      meta: result.meta || {},
      filterParams: params,
      page: params.page || 1,
      totalPages: result.meta?.total_pages || 1,
      isLastPage: (params.page || 1) >= (result.meta?.total_pages || 1)
    };
  }
}
