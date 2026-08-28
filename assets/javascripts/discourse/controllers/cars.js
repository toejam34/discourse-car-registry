<<<<<<< HEAD
import Controller from "@ember/controller";
import { action } from "@ember/object";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";

import AddEditCarModal from "discourse/components/modal/add-edit-car-modal";
=======
import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { debounce } from '@ember/runloop';
import { service } from '@ember/service';
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410

export default class CarsController extends Controller {
  @service router;
  @service modal;
  @service currentUser;

<<<<<<< HEAD
  queryParams = ["q", "page", "model_id", "location_id"];

  q = "";
  page = 1;
  model_id = 0;
  location_id = 0;

  get models() {
    return this.model?.meta?.models || [];
  }

  get locations() {
    return this.model?.meta?.locations || [];
  }

  get totalPages() {
    return this.model?.meta?.total_pages || 1;
  }

  get isFirstPage() {
    return Number(this.page) <= 1;
  }

  get isLastPage() {
    return Number(this.page) >= this.totalPages;
  }

  isSelected(value, selected) {
    return String(value) === String(selected);
  }
=======
  queryParams = ['q', 'page', 'model_id', 'location_id'];

  @tracked q = '';
  @tracked page = 1;
  @tracked model_id = null;
  @tracked location_id = null;
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410

  @action
  onSearch(event) {
    this.q = event.target.value;
    this.page = 1;
<<<<<<< HEAD
    debounce(this, this.applySearch, 400);
  }

  applySearch() {
    this.router.transitionTo("cars", {
      queryParams: { q: this.q, page: 1 },
    });
  }

  @action
  onModelChange(event) {
    this.router.transitionTo("cars", {
      queryParams: { model_id: event.target.value, page: 1 },
    });
  }

  @action
  onLocationChange(event) {
    this.router.transitionTo("cars", {
      queryParams: { location_id: event.target.value, page: 1 },
    });
  }

  @action
  resetFilters() {
    this.router.transitionTo("cars", {
      queryParams: { q: "", model_id: 0, location_id: 0, page: 1 },
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
  async openRegisterModal() {
    await this.modal.show(AddEditCarModal, {
      model: {
        car: null,
        meta: this.model.meta,
        onSuccess: () => this.router.refresh(),
      },
    });
  }

  @action
  async openEditModal(car) {
    await this.modal.show(AddEditCarModal, {
      model: {
        car,
        meta: this.model.meta,
        onSuccess: () => this.router.refresh(),
      },
=======
    debounce(this, this.performSearch, 400);
  }

  performSearch() {
    this.router.transitionTo({
      queryParams: {
        q: this.q,
        page: this.page
      }
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
    });
  }
}
