import Controller from "@ember/controller";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { debounce } from "@ember/runloop";
import { service } from "@ember/service";

export default class CarsController extends Controller {
  @service router;

  queryParams = ["searchTerm", "selectedModelId", "selectedLocationId", "page"];

  @tracked searchTerm = "";
  @tracked selectedModelId = "0";
  @tracked selectedLocationId = "0";
  @tracked page = 1;

  @action
  onSearch(event) {
    // 1. Immediately update the tracked property so the input box stays in sync visually
    this.searchTerm = event.target.value;
    this.page = 1; // Reset to page 1 on new search

    // 2. Debounce the actual query transition so it doesn't interrupt typing
    debounce(this, this.performSearch, 400);
  }

  performSearch() {
    this.router.transitionTo({
      queryParams: {
        searchTerm: this.searchTerm,
        page: this.page
      }
    });
  }

  @action
  onModelChange(event) {
    this.selectedModelId = event.target.value;
    this.page = 1;
    this.router.transitionTo({
      queryParams: {
        selectedModelId: this.selectedModelId,
        page: this.page
      }
    });
  }

  @action
  onLocationChange(event) {
    this.selectedLocationId = event.target.value;
    this.page = 1;
    this.router.transitionTo({
      queryParams: {
        selectedLocationId: this.selectedLocationId,
        page: this.page
      }
    });
  }

  @action
  resetFilters() {
    this.searchTerm = "";
    this.selectedModelId = "0";
    this.selectedLocationId = "0";
    this.page = 1;
    this.router.transitionTo({
      queryParams: {
        searchTerm: "",
        selectedModelId: "0",
        selectedLocationId: "0",
        page: 1
      }
    });
  }

  @action
  previousPage() {
    if (this.page > 1) {
      this.page -= 1;
      this.router.transitionTo({ queryParams: { page: this.page } });
    }
  }

  @action
  nextPage() {
    if (!this.isLastPage) {
      this.page += 1;
      this.router.transitionTo({ queryParams: { page: this.page } });
    }
  }

  get isLastPage() {
    return this.page >= (this.model?.meta?.total_pages || 1);
  }
}
