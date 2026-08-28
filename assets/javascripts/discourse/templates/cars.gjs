import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import DButton from "discourse/components/d-button";
import i18n from "discourse/helpers/i18n";

<template>
  <div class="car-registry-container wrap">
    <div class="car-registry-header">
      <h1>{{i18n "car_registry.title"}}</h1>
      <div class="car-registry-actions">
        {{#if @controller.currentUser}}
          <DButton
            @translatedLabel={{i18n "car_registry.register_button"}}
            @icon="plus"
            @action={{@controller.openRegisterModal}}
            class="btn-primary"
          />
        {{/if}}
      </div>
    </div>

    <div class="car-registry-filters">
      <div class="filter-input">
        <input
          type="search"
          value={{@controller.searchValue}}
          placeholder={{i18n "car_registry.filters.search_placeholder"}}
          {{on "input" @controller.onSearch}}
          class="form-control"
          autocomplete="off"
        />
      </div>

      <select
        class="form-control"
        value={{@controller.model_id}}
        {{on "change" @controller.onModelChange}}
      >
        <option value="">{{i18n "car_registry.filters.all_models"}}</option>
        {{#each @model.meta.models as |carModel|}}
          <option value={{carModel.id}}>{{carModel.name}}</option>
        {{/each}}
      </select>

      <select
        class="form-control"
        value={{@controller.location_id}}
        {{on "change" @controller.onLocationChange}}
      >
        <option value="">{{i18n "car_registry.filters.all_locations"}}</option>
        {{#each @model.meta.locations as |location|}}
          <option value={{location.id}}>{{location.name}}</option>
        {{/each}}
      </select>

      <DButton
        @translatedLabel={{i18n "car_registry.filters.reset"}}
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
            <th>{{i18n "car_registry.columns.actions"}}</th>
          </tr>
        </thead>
        <tbody>
          {{#each @model.cars as |car|}}
            <tr>
              <td class="member-col">
                {{#if car.avatar_url}}
                  <a href="/u/{{car.username}}">
                    <img src={{car.avatar_url}} alt="" width="32" height="32" />
                    <span>{{car.username}}</span>
                  </a>
                {{else}}
                  <span>{{car.username}}</span>
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
                    @title={{i18n "car_registry.edit_button"}}
                    @action={{fn @controller.openEditModal car}}
                    class="btn-default btn-small"
                  />
                {{/if}}
              </td>
            </tr>
          {{else}}
            <tr>
              <td colspan="11" class="car-registry-empty">
                <p>{{i18n "car_registry.no_results"}}</p>
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>

    <div class="car-registry-pagination">
      <DButton
        @icon="chevron-left"
        @action={{@controller.previousPage}}
        @disabled={{@controller.isFirstPage}}
        class="btn-default"
      />

      <span class="page-indicator">
        {{i18n "car_registry.pagination" current=@controller.page total=@model.meta.total_pages}}
      </span>

      <DButton
        @icon="chevron-right"
        @action={{@controller.nextPage}}
        @disabled={{@controller.isLastPage}}
        class="btn-default"
      />
    </div>
  </div>
</template>
