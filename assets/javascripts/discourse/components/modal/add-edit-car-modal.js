import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import { ajax } from "discourse/lib/ajax";

export default class AddEditCarModal extends Component {
  @tracked carModel = this.args.model?.car?.model || "";
  @tracked colour = this.args.model?.car?.colour || "";
  @tracked trim = this.args.model?.car?.trim || "";
  @tracked location = this.args.model?.car?.location || "";
  @tracked plaqueNumber = this.args.model?.car?.plaque_number || "";
  @tracked regNumber = this.args.model?.car?.reg_number || "";
  @tracked forumName = this.args.model?.car?.forum_name || "";
  @tracked uniqueInfo = this.args.model?.car?.unique_info || "";

  @action
  async save() {
    const payload = {
      model: this.carModel,
      colour: this.colour,
      trim: this.trim,
      location: this.location,
      plaque_number: this.plaqueNumber,
      reg_number: this.regNumber,
      forum_name: this.forumName,
      unique_info: this.uniqueInfo,
    };

    const carId = this.args.model?.car?.id;
    const url = carId ? `/car_registry/${carId}` : "/car_registry";
    const method = carId ? "PUT" : "POST";

    try {
      await ajax(url, { type: method, data: payload });
      if (this.args.model?.onSave) {
        this.args.model.onSave();
      }
      this.args.closeModal();
    } catch (error) {
      // System notification for failed requests
    }
  }
}
