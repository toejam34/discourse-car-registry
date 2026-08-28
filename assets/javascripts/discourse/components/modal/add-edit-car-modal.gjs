import { on } from "@ember/modifier";
<<<<<<< HEAD
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import i18n from "discourse/helpers/i18n";
import { ajax } from "discourse/lib/ajax";

export default class AddEditCarModal extends Component {
  @tracked modelId = this.args.model?.car?.model_id || 0;
  @tracked locationId = this.args.model?.car?.location_id || 0;
  @tracked colour = this.args.model?.car?.colour || "";
  @tracked trim = this.args.model?.car?.trim || "";
  @tracked plaqueNumber = this.args.model?.car?.plaque_number || "";
  @tracked regNumber = this.args.model?.car?.reg_number || "";
  @tracked carRegDate = this.args.model?.car?.car_reg_date || "";
  @tracked forumName = this.args.model?.car?.forum_name || "";
  @tracked uniqueInformation = this.args.model?.car?.unique_information || "";
  @tracked isSaving = false;
  @tracked error = null;

  get isEdit() {
    return Boolean(this.args.model?.car?.id);
  }

  isSelected(value, selected) {
    return String(value) === String(selected);
  }

  update(field, event) {
    this[field] = event.target.value;
  }

  @action
  updateModelId(event) {
    this.modelId = Number(event.target.value);
  }

  @action
  updateLocationId(event) {
    this.locationId = Number(event.target.value);
  }

  @action
  updateText(field, event) {
    this[field] = event.target.value;
=======
import { Input } from "@ember/component";
import Component from "@glimmer/component";
import { action } from "@ember/object";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";
import DButton from "discourse/components/d-button";
import DModal from "discourse/components/d-modal";
import i18n from "discourse/helpers/i18n";
import { eq } from "truth-helpers";
import { ajax } from "discourse/lib/ajax";

export default class AddEditCarModal extends Component {
  @service modal;

  @tracked modelId = this.args.model.car?.model_id || 0;
  @tracked locationId = this.args.model.car?.location_id || 0;
  @tracked colour = this.args.model.car?.colour || "";
  @tracked trim = this.args.model.car?.trim || "";
  @tracked plaqueNumber = this.args.model.car?.plaque_number || "";
  @tracked regNumber = this.args.model.car?.reg_number || "";
  @tracked carRegDate = this.args.model.car?.car_reg_date || "";
  @tracked forumName = this.args.model.car?.forum_name || "";
  @tracked uniqueInformation = this.args.model.car?.unique_information || "";
  @tracked isSaving = false;

  <template>
    <DModal
      @title={{if @model.car.id (i18n "car_registry.edit_title") (i18n "car_registry.register_title")}}
      @closeModal={{@closeModal}}
      class="add-edit-car-modal"
    >
      <:body>
        <div class="form-horizontal">
          <div class="control-group">
            <label>{{i18n "car_registry.columns.model"}}</label>
            <select class="form-control" {{on "change" this.updateModelId}}>
              <option value="0">Select Model</option>
              {{#each @model.meta.models as |m|}}
                <option value={{m.id}} selected={{eq this.modelId m.id}}>{{m.name}}</option>
              {{/each}}
            </select>
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.location"}}</label>
            <select class="form-control" {{on "change" this.updateLocationId}}>
              <option value="0">Select Location</option>
              {{#each @model.meta.locations as |l|}}
                <option value={{l.id}} selected={{eq this.locationId l.id}}>{{l.name}}</option>
              {{/each}}
            </select>
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.colour"}}</label>
            <Input @type="text" @value={{this.colour}} class="form-control" />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.trim"}}</label>
            <Input @type="text" @value={{this.trim}} class="form-control" />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.plaque"}}</label>
            <Input @type="text" @value={{this.plaqueNumber}} class="form-control" />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.reg_number"}}</label>
            <Input @type="text" @value={{this.regNumber}} class="form-control" />
          </div>

          <div class="control-group">
            <label>{{i18n "car_registry.columns.unique_info"}}</label>
            <Input @type="text" @value={{this.uniqueInformation}} class="form-control" />
          </div>
        </div>
      </:body>
      <:footer>
        <DButton
          @label="save"
          @action={{this.save}}
          @disabled={{this.isSaving}}
          class="btn-primary"
        />
        <DButton
          @label="cancel"
          @action={{@closeModal}}
          class="btn-default"
        />
      </:footer>
    </DModal>
  </template>

  @action
  updateModelId(e) {
    this.modelId = parseInt(e.target.value, 10);
  }

  @action
  updateLocationId(e) {
    this.locationId = parseInt(e.target.value, 10);
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
  }

  @action
  async save() {
    this.isSaving = true;
<<<<<<< HEAD
    this.error = null;

    const payload = {
      car: {
        model_id: this.modelId || null,
        location_id: this.locationId || null,
=======

    const payload = {
      car: {
        model_id: this.modelId,
        location_id: this.locationId,
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
        colour: this.colour,
        trim: this.trim,
        plaque_number: this.plaqueNumber,
        reg_number: this.regNumber,
<<<<<<< HEAD
        car_reg_date: this.carRegDate || null,
        forum_name: this.forumName,
        unique_information: this.uniqueInformation,
      },
    };

    try {
      const id = this.args.model?.car?.id;
      await ajax(id ? `/cars/${id}.json` : "/cars.json", {
        type: id ? "PUT" : "POST",
        data: payload,
      });
      await this.args.model?.onSuccess?.();
      this.args.closeModal();
    } catch (e) {
      this.error = e?.json?.errors?.join(" ") || e?.message || "Unable to save vehicle.";
=======
        unique_information: this.uniqueInformation
      }
    };

    try {
      if (this.args.model.car?.id) {
        await ajax(`/cars/${this.args.model.car.id}.json`, {
          type: "PUT",
          data: payload
        });
      } else {
        await ajax("/cars.json", {
          type: "POST",
          data: payload
        });
      }

      this.args.closeModal();
      if (this.args.model.onSuccess) {
        this.args.model.onSuccess();
      }
    } catch (error) {
      // Handle error
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
    } finally {
      this.isSaving = false;
    }
  }
<<<<<<< HEAD

  <template>
    <DModal
      @title={{if this.isEdit (i18n "car_registry.modal.title_edit") (i18n "car_registry.modal.title_new")}}
      @closeModal={{@closeModal}}
      class="add-edit-car-modal"
    >
      <:body>
        {{#if this.error}}
          <div class="alert alert-error">{{this.error}}</div>
        {{/if}}

        <div class="form-horizontal">
          <label>{{i18n "car_registry.modal.model_label"}}</label>
          <select class="form-control" {{on "change" this.updateModelId}}>
            <option value="0">{{i18n "car_registry.filters.all_models"}}</option>
            {{#each @model.meta.models as |model|}}
              <option value={{model.id}} selected={{this.isSelected model.id this.modelId}}>{{model.name}}</option>
            {{/each}}
          </select>

          <label>{{i18n "car_registry.modal.location_label"}}</label>
          <select class="form-control" {{on "change" this.updateLocationId}}>
            <option value="0">{{i18n "car_registry.filters.all_locations"}}</option>
            {{#each @model.meta.locations as |location|}}
              <option value={{location.id}} selected={{this.isSelected location.id this.locationId}}>{{location.name}}</option>
            {{/each}}
          </select>

          <label>{{i18n "car_registry.modal.colour_label"}}</label>
          <input class="form-control" value={{this.colour}} {{on "input" (fn this.updateText "colour")}} />
          <label>{{i18n "car_registry.modal.trim_label"}}</label>
          <input class="form-control" value={{this.trim}} {{on "input" (fn this.updateText "trim")}} />
          <label>{{i18n "car_registry.modal.plaque_label"}}</label>
          <input class="form-control" value={{this.plaqueNumber}} {{on "input" (fn this.updateText "plaqueNumber")}} />
          <label>{{i18n "car_registry.modal.reg_number_label"}}</label>
          <input class="form-control" value={{this.regNumber}} {{on "input" (fn this.updateText "regNumber")}} />
          <label>{{i18n "car_registry.columns.reg_date"}}</label>
          <input type="date" class="form-control" value={{this.carRegDate}} {{on "input" (fn this.updateText "carRegDate")}} />
          <label>{{i18n "car_registry.modal.forum_name_label"}}</label>
          <input class="form-control" value={{this.forumName}} {{on "input" (fn this.updateText "forumName")}} />
          <label>{{i18n "car_registry.modal.unique_info_label"}}</label>
          <textarea class="form-control" rows="4" {{on "input" (fn this.updateText "uniqueInformation")}}>{{this.uniqueInformation}}</textarea>
        </div>
      </:body>
      <:footer>
        <DButton @label="car_registry.modal.save_button" @action={{this.save}} @disabled={{this.isSaving}} class="btn-primary" />
        <DButton @label="cancel" @action={{@closeModal}} class="btn-default" />
      </:footer>
    </DModal>
  </template>
=======
>>>>>>> 81f8a4b38aae8797e7a8367cbae3cb10838da410
}
