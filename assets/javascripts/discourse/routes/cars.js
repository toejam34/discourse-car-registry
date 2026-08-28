import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { debounce } from '@ember/runloop';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import Component from '@glimmer/component';

class CarsController {
  @tracked q = '';
  @service router;

  @action
  onSearch(event) {
    this.q = event.target.value;
    debounce(this, this.performSearch, 400);
  }

  performSearch() {
    this.router.transitionTo({
      queryParams: {
        q: this.q,
        page: 1
      }
    });
  }
}

<template>
  <div class="car-registry-container">
    <div class="car-registry-header">
      <h1>Car Registry</h1>
      <div class="filter-input">
        <input
          type="text"
          value={{@model.filterParams.q}}
          placeholder="Search cars..."
          {{on "input" this.onSearch}}
          class="form-control"
        />
      </div>
    </div>

    <div class="car-registry-content">
      <table class="table">
        <thead>
          <tr>
            <th>Vehicle</th>
            <th>Location</th>
            <th>Model</th>
          </tr>
        </thead>
        <tbody>
          {{#each @model.cars as |car|}}
            <tr>
              <td>{{car.name}}</td>
              <td>{{car.location}}</td>
              <td>{{car.model}}</td>
            </tr>
          {{else}}
            <tr>
              <td colspan="3">No cars found.</td>
            </tr>
          {{#each}}
        </tbody>
      </table>
    </div>
  </div>
</template>

export default class CarsRoute extends Route {
  @service store;

  queryParams = {
    q: { refreshModel: true },
    page: { refreshModel: true },
    model_id: { refreshModel: true },
    location_id: { refreshModel: true }
  };

  async model(params) {
    // Fetch cars from your store or backend API matching params
    const result = await this.store.query('car-registry-item', params);
    return {
      cars: result,
      filterParams: params
    };
  }
}
