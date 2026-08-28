import Controller from "@ember/controller";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import AddEditCarModal from "../components/modal/add-edit-car-modal";

export default class CarsController extends Controller {
  @service currentUser;
  @service modal;
  @service router;

  queryParams = ["q", "page", "model_id", "location_id"];

  q = "";
  page = 1;
  model_id = "";
  location_id = "";

  @tracked searchValue = "";

  constructor(...args) {
    super(...args);
    this.searchValue = this.q || "";
  }

  get isFirstPage() {
    return Number(this.page) <= 1;
  }

  get isLastPage() {
    return Number(this.page) >= Number(this.model?.meta?.total_pages || 1);
  }

  @action
  onSearch(event) {
    this.searchValue = event.target.value;
    debounce(this, this.applySearch, 400);
  }

  @action
  onModelChange(event) {
    this.router.transitionTo("cars", {
      queryParams: {
        q: this.q || "",
        model_id: event.target.value || "",
        location_id: this.location_id || "",
        page: 1,
      },
    });
  }

  @action
  onLocationChange(event) {
    this.router.transitionTo("cars", {
      queryParams: {
        q: this.q || "",
        model_id: this.model_id || "",
        location_id: event.target.value || "",
        page: 1,
      },
    });
  }

  @action
  resetFilters() {
    this.searchValue = "";
    this.router.transitionTo("cars", {
      queryParams: {
        q: "",
        model_id: "",
        location_id: "",
        page: 1,
      },
    });
  }

  @action
  previousPage() {
    if (!this.isFirstPage) {
      this.router.transitionTo("cars", {
        queryParams: { page: Number(this.page) - 1 },
      });
    }
  }

  @action
  nextPage() {
    if (!this.isLastPage) {
      this.router.transitionTo("cars", {
        queryParams: { page: Number(this.page) + 1 },
      });
    }
  }

  @action
  openRegisterModal() {
    this.modal.show(AddEditCarModal, {
      model: {
        car: null,
        meta: this.model.meta,
        onSuccess: () => this.router.refresh(),
      },
    });
  }

  @action
  openEditModal(car) {
    this.modal.show(AddEditCarModal, {
      model: {
        car,
        meta: this.model.meta,
        onSuccess: () => this.router.refresh(),
      },
    });
  }

  applySearch() {
    this.router.transitionTo("cars", {
      queryParams: {
        q: this.searchValue || "",
        model_id: this.model_id || "",
        location_id: this.location_id || "",
        page: 1,
      },
    });
  }
}
