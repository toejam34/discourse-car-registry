import Route from "@ember/routing/route";
import { ajax } from "discourse/lib/ajax";

export default class CarsRoute extends Route {
  queryParams = {
    page: { refreshModel: true },
    model_id: { refreshModel: true },
    location_id: { refreshModel: true },
    q: { refreshModel: true }
  };

  async model(params) {
    const [carsData, metaData] = await Promise.all([
      ajax("/cars.json", { data: params }),
      ajax("/cars/meta.json")
    ]);

    return {
      cars: carsData.cars,
      pagination: carsData.meta,
      meta: metaData,
      params: params
    };
  }
}
