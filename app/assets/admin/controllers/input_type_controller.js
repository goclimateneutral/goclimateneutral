import { Controller } from 'stimulus';

export default class InputTypeController extends Controller {
  initialize() {
    this.update();
  }

  update() {
    this.inputTarget.type = this.typeTarget.selectedOptions[0].dataset.inputType;
  }
}

InputTypeController.targets = ['type', 'input'];
