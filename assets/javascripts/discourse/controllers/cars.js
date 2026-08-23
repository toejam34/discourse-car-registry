import Controller from "@ember/controller";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import showModal from "discourse/lib/show-modal";

export default class CarsController extends Controller {
  @service currentUser;
  @service router;

  @tracked searchTerm = "";
  @tracked selectedModelId = 0;
  @tracked selectedLocationId = 0;

  @action
  onSearch(event) {
    this.searchTerm = event.target.value;
    this.router.transitionTo("cars", {
      queryParams: { q: this.searchTerm, page: 1 }
    });
  }

  @action
  onModelChange(event) {
    this.selectedModelId = event.target.value;
    this.router.transitionTo("cars", {
      queryParams: { model_id: this.selectedModelId, page: 1 }
    });
  }

  @action
  onLocationChange(event) {
    this.selectedLocationId = event.target.value;
    this.router.transitionTo("cars", {
      queryParams: { location_id: this.selectedLocationId, page: 1 }
    });
  }

  @action
  resetFilters() {
    this.searchTerm = "";
    this.selectedModelId = 0;
    this.selectedLocationId = 0;
    this.router.transitionTo("cars", {
      queryParams: { q: "", model_id: 0, location_id: 0, page: 1 }
    });
  }

  @action
  openRegisterModal() {
    showModal("add-edit-car-modal", {
      model: {
        car: {},
        meta: this.model.meta,
        onSuccess: () => this.send("reloadModel")
      }
    });
  }

  @action
  openEditModal(car) {
    showModal("add-edit-car-modal", {
      model: {
        car: car,
        meta: this.model.meta,
        onSuccess: () => this.send("reloadModel")
      }
    });
  }
}
