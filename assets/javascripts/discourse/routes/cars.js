import Route from "@ember/routing/route";
import { ajax } from "discourse/lib/ajax";

export default class CarsRoute extends Route {
  queryParams = {
    q: { refreshModel: true },
    model_id: { refreshModel: true },
    location_id: { refreshModel: true },
    page: { refreshModel: true },
  };

  model(params) {
    return ajax("/cars.json", {
      data: {
        q: params.q || "",
        model_id: params.model_id || 0,
        location_id: params.location_id || 0,
        page: params.page || 1,
      },
    });
  }
}
