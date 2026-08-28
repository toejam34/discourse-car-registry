import Route from "@ember/routing/route";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class CarsRoute extends Route {
  queryParams = {
    q: { refreshModel: true },
    model_id: { refreshModel: true },
    location_id: { refreshModel: true },
    page: { refreshModel: true },
  };

  async model(params) {
    const page = Math.max(Number.parseInt(params.page, 10) || 1, 1);
    const query = {
      q: params.q || undefined,
      model_id: params.model_id || undefined,
      location_id: params.location_id || undefined,
      page,
    };

    const [registry, meta] = await Promise.all([
      ajax("/cars.json", { data: query }),
      ajax("/cars/meta.json"),
    ]);

    return {
      cars: registry.cars || [],
      meta: {
        ...(registry.meta || {}),
        models: meta.models || [],
        locations: meta.locations || [],
        colours: meta.colours || [],
      },
    };
  }
}
