import { on } from "@ember/modifier";
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import DModalCancel from "discourse/components/d-modal-cancel";
import i18n from "discourse/helpers/i18n";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class AddEditCarModal extends Component {
  @tracked modelId = this.args.model?.car?.model_id ?? "";
  @tracked locationId = this.args.model?.car?.location_id ?? "";
  @tracked colour = this.args.model?.car?.colour ?? "";
  @tracked trim = this.args.model?.car?.trim ?? "";
  @tracked plaqueNumber = this.args.model?.car?.plaque_number ?? "";
  @tracked regNumber = this.args.model?.car?.reg_number ?? "";
  @tracked carRegDate = this.args.model?.car?.car_reg_date ?? "";
  @tracked forumName = this.args.model?.car?.forum_name ?? "";
  @tracked uniqueInformation = this.args.model?.car?.unique_information ?? "";
  @tracked isSaving = false;
  @tracked errorMessage = "";

  get isEditing() {
    return Boolean(this.args.model?.car?.id);
  }

  get titleKey() {
    return this.isEditing
      ? "car_registry.modal.title_edit"
      : "car_registry.modal.title_new";
  }

  get models() {
    return this.args.model?.meta?.models || [];
  }

  get locations() {
    return this.args.model?.meta?.locations || [];
  }

  <template>
    <DModal
      @title={{i18n this.titleKey}}
      @flash={{this.errorMessage}}
      @closeModal={{@closeModal}}
      class="add-edit-car-modal"
    >
      <:body>
        <div class="form-horizontal">
          <div class="control-group">
            <label>{{i18n "car_registry.modal.model_label"}}</label>
            <select class="form-control" value={{this.modelId}} {{on "change" this.updateModelId}}>
              <option value="">{{i18n "car_registry.filters.all_models"}}</option>
              {{#each this.models as |model|}}
                <option value={{model.id}}>{{model.name}}</option>
              {{/each}}
            </select>
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.location_label"}}</label>
            <select class="form-control" value={{this.locationId}} {{on "change" this.updateLocationId}}>
              <option value="">{{i18n "car_registry.filters.all_locations"}}</option>
              {{#each this.locations as |location|}}
                <option value={{location.id}}>{{location.name}}</option>
              {{/each}}
            </select>
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.colour_label"}}</label>
            <input class="form-control" value={{this.colour}} {{on "input" this.updateColour}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.trim_label"}}</label>
            <input class="form-control" value={{this.trim}} {{on "input" this.updateTrim}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.plaque_label"}}</label>
            <input class="form-control" value={{this.plaqueNumber}} {{on "input" this.updatePlaqueNumber}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.reg_number_label"}}</label>
            <input class="form-control" value={{this.regNumber}} {{on "input" this.updateRegNumber}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.reg_date_label"}}</label>
            <input type="date" class="form-control" value={{this.carRegDate}} {{on "input" this.updateCarRegDate}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.forum_name_label"}}</label>
            <input class="form-control" value={{this.forumName}} {{on "input" this.updateForumName}} />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.modal.unique_info_label"}}</label>
            <textarea class="form-control" rows="5" {{on "input" this.updateUniqueInformation}}>{{this.uniqueInformation}}</textarea>
          </div>
        </div>
      </:body>

      <:footer>
        {{#if this.isEditing}}
          <DButton
            @translatedLabel={{i18n "car_registry.modal.delete_button"}}
            @action={{this.remove}}
            @disabled={{this.isSaving}}
            class="btn-danger"
          />
        {{/if}}
        <DModalCancel @close={{@closeModal}} />
        <DButton
          @translatedLabel={{i18n "car_registry.modal.save_button"}}
          @action={{this.save}}
          @disabled={{this.isSaving}}
          class="btn-primary"
        />
      </:footer>
    </DModal>
  </template>

  @action
  updateModelId(event) { this.modelId = event.target.value; }
  @action
  updateLocationId(event) { this.locationId = event.target.value; }
  @action
  updateColour(event) { this.colour = event.target.value; }
  @action
  updateTrim(event) { this.trim = event.target.value; }
  @action
  updatePlaqueNumber(event) { this.plaqueNumber = event.target.value; }
  @action
  updateRegNumber(event) { this.regNumber = event.target.value; }
  @action
  updateCarRegDate(event) { this.carRegDate = event.target.value; }
  @action
  updateForumName(event) { this.forumName = event.target.value; }
  @action
  updateUniqueInformation(event) { this.uniqueInformation = event.target.value; }

  buildPayload() {
    return {
      car: {
        model_id: this.modelId || null,
        location_id: this.locationId || null,
        colour: this.colour,
        trim: this.trim,
        plaque_number: this.plaqueNumber,
        reg_number: this.regNumber,
        car_reg_date: this.carRegDate || null,
        forum_name: this.forumName,
        unique_information: this.uniqueInformation,
      },
    };
  }

  @action
  async save() {
    this.isSaving = true;
    this.errorMessage = "";

    try {
      const id = this.args.model?.car?.id;
      await ajax(id ? `/cars/${id}.json` : "/cars.json", {
        type: id ? "PUT" : "POST",
        data: this.buildPayload(),
      });

      this.args.model?.onSuccess?.();
      this.args.closeModal();
    } catch (error) {
      popupAjaxError(error);
      this.errorMessage = error?.message || "Unable to save this vehicle.";
    } finally {
      this.isSaving = false;
    }
  }

  @action
  async remove() {
    if (!window.confirm("Are you sure you want to remove this vehicle from the registry?")) {
      return;
    }

    this.isSaving = true;
    this.errorMessage = "";

    try {
      await ajax(`/cars/${this.args.model.car.id}.json`, { type: "DELETE" });
      this.args.model?.onSuccess?.();
      this.args.closeModal();
    } catch (error) {
      popupAjaxError(error);
      this.errorMessage = error?.message || "Unable to remove this vehicle.";
    } finally {
      this.isSaving = false;
    }
  }
}
