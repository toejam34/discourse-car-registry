import { on } from "@ember/modifier";
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
  }

  @action
  async save() {
    this.isSaving = true;

    const payload = {
      car: {
        model_id: this.modelId,
        location_id: this.locationId,
        colour: this.colour,
        trim: this.trim,
        plaque_number: this.plaqueNumber,
        reg_number: this.regNumber,
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
    } finally {
      this.isSaving = false;
    }
  }
}
