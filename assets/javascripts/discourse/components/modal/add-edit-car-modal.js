import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default class AddEditCarModal extends Component {
  @tracked modelId = this.args.model.car.model_id || 0;
  @tracked locationId = this.args.model.car.location_id || 0;
  @tracked colour = this.args.model.car.colour || "";
  @tracked trim = this.args.model.car.trim || "";
  @tracked plaqueNumber = this.args.model.car.plaque_number || "";
  @tracked regNumber = this.args.model.car.reg_number || "";
  @tracked carRegDate = this.args.model.car.car_reg_date || "";
  @tracked forumName = this.args.model.car.forum_name || "";
  @tracked uniqueInformation = this.args.model.car.unique_information || "";
  @tracked saving = false;

  get isEditing() {
    return Boolean(this.args.model.car.id);
  }

  @action
  async saveCar() {
    this.saving = true;
    const payload = {
      car: {
        model_id: this.modelId,
        location_id: this.locationId,
        colour: this.colour,
        trim: this.trim,
        plaque_number: this.plaqueNumber,
        reg_number: this.regNumber,
        car_reg_date: this.carRegDate,
        forum_name: this.forumName,
        unique_information: this.uniqueInformation
      }
    };

    try {
      if (this.isEditing) {
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
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.saving = false;
    }
  }

  @action
  async deleteCar() {
    if (!confirm(I18n.t("car_registry.modal.delete_confirm"))) return;

    this.saving = true;
    try {
      await ajax(`/cars/${this.args.model.car.id}.json`, { type: "DELETE" });
      this.args.closeModal();
      if (this.args.model.onSuccess) {
        this.args.model.onSuccess();
      }
    } catch (e) {
      popupAjaxError(e);
    } finally {
      this.saving = false;
    }
  }
}
