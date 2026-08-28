import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { debounce } from '@ember/runloop';
import { service } from '@ember/service';

export default class CarsController extends Controller {
  @service router;

  queryParams = ['q', 'page', 'model_id', 'location_id'];

  @tracked q = '';
  @tracked page = 1;
  @tracked model_id = null;
  @tracked location_id = null;

  @action
  onSearch(event) {
    this.q = event.target.value;
    this.page = 1;
    debounce(this, this.performSearch, 400);
  }

  performSearch() {
    this.router.transitionTo({
      queryParams: {
        q: this.q,
        page: this.page
      }
    });
  }
}
