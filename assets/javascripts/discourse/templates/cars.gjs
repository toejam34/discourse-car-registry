import { on } from "@ember/modifier";
import { fn } from "@ember/helper";
import DButton from "discourse/components/d-button";
import avatar from "discourse/helpers/avatar";
import i18n from "discourse/helpers/i18n";

<template>
  <div class="car-registry-container wrap">
    <div class="car-registry-header">
      <h1>{{i18n "car_registry.title"}}</h1>
      {{#if @controller.currentUser}}
        <DButton
          @label="car_registry.register_button"
          @icon="plus"
          @action={{@controller.openRegisterModal}}
          class="btn-primary"
        />
      {{/if}}
    </div>

    <div class="car-registry-filters">
      <input
        type="search"
        class="form-control"
        value={{@controller.q}}
        placeholder={{i18n "car_registry.filters.search_placeholder"}}
        {{on "input" @controller.onSearch}}
      />

      <select class="form-control" value={{@controller.model_id}} {{on "change" @controller.onModelChange}}>
        <option value="0">{{i18n "car_registry.filters.all_models"}}</option>
        {{#each @controller.models as |carModel|}}
          <option value={{carModel.id}} selected={{@controller.isSelected carModel.id @controller.model_id}}>
            {{carModel.name}}
          </option>
        {{/each}}
      </select>

      <select class="form-control" value={{@controller.location_id}} {{on "change" @controller.onLocationChange}}>
        <option value="0">{{i18n "car_registry.filters.all_locations"}}</option>
        {{#each @controller.locations as |location|}}
          <option value={{location.id}} selected={{@controller.isSelected location.id @controller.location_id}}>
            {{location.name}}
          </option>
        {{/each}}
      </select>

      <DButton
        @label="car_registry.filters.reset"
        @icon="sync"
        @action={{@controller.resetFilters}}
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
                {{#if car.username}}
                  <a href="/u/{{car.username}}">
                    {{avatar car imageSize="small"}}
                    <span>{{car.username}}</span>
                  </a>
                {{else}}
                  <span>unknown</span>
                {{/if}}
              </td>
              <td><strong>{{car.model_name}}</strong></td>
              <td>{{car.colour}}</td>
              <td>{{car.trim}}</td>
              <td>{{car.location_name}}</td>
              <td>{{car.plaque_number}}</td>
              <td>{{car.reg_number}}</td>
              <td>{{car.car_reg_date_formatted}}</td>
              <td>{{car.forum_name}}</td>
              <td class="notes-col" title={{car.unique_information}}>{{car.unique_information}}</td>
              <td>
                {{#if car.can_edit}}
                  <DButton @icon="pencil-alt" @action={{fn @controller.openEditModal car}} class="btn-default btn-small" />
                {{/if}}
              </td>
            </tr>
          {{else}}
            <tr>
              <td colspan="11" class="car-registry-empty">No vehicles found.</td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>

    <div class="car-registry-pagination">
      <DButton @icon="chevron-left" @action={{@controller.previousPage}} @disabled={{@controller.isFirstPage}} />
      <span>Page {{@controller.page}} of {{@controller.totalPages}}</span>
      <DButton @icon="chevron-right" @action={{@controller.nextPage}} @disabled={{@controller.isLastPage}} />
    </div>
  </div>
</template>
