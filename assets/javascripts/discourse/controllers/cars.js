import Controller from "@ember/controller";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import AddEditCarModal from "../components/modal/add-edit-car-modal";

export default class CarsController extends Controller {
  @service currentUser;
  @service router;
  @service modal;

  queryParams = ["page", "model_id", "location_id", "q"];

  @tracked page = 1;
  @tracked searchTerm = "";
  @tracked selectedModelId = 0;
  @tracked selectedLocationId = 0;

  get totalPages() {
    return this.model?.pagination?.total_pages || 1;
  }

  get isLastPage() {
    const currentPage = parseInt(this.page || 1, 10);
    return currentPage >= this.totalPages;
  }

  @action
  previousPage() {
    const currentPage = parseInt(this.page || 1, 10);
    if (currentPage > 1) {
      this.router.transitionTo("cars", {
        queryParams: { page: currentPage - 1 }
      });
    }
  }

  @action
  nextPage() {
    const currentPage = parseInt(this.page || 1, 10);
    if (!this.isLastPage) {
      this.router.transitionTo("cars", {
        queryParams: { page: currentPage + 1 }
      });
    }
  }

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
    this.modal.show(AddEditCarModal, {
      model: {
        car: {},
        meta: this.model.meta,
        onSuccess: () => this.send("reloadModel")
      }
    });
  }

  @action
  openEditModal(car) {
    this.modal.show(AddEditCarModal, {
      model: {
        car: car,
        meta: this.model.meta,
        onSuccess: () => this.send("reloadModel")
      }
    });
  }
}
