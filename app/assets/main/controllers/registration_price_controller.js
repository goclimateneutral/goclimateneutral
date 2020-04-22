import { Controller } from 'stimulus';
import submitForm from '../../util/submit_form';

export default class RegistrationPriceController extends Controller {
  update() {
    const people = this.peopleFormTarget.people.value;
    submitForm(this.peopleFormTarget, { headers: { Accept: 'application/json' } })
      .then((response) => response.json())
      .then((response) => {
        this.peopleFieldTarget.value = people;
        this.priceTargets.forEach((priceTarget) => {
          priceTarget.innerText = response.price;
        });
      });
  }
}

RegistrationPriceController.targets = ['peopleForm', 'price', 'peopleField'];
