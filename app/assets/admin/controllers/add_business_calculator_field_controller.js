import { Controller } from 'stimulus';

export default class AddBusinessCalculatorFieldController extends Controller {
  cloneToDestination() {
    const clone = this.templateTarget.cloneNode(true);
    clone.classList.remove('hidden');
    clone.dataset.target = clone.dataset.target.replace('add-business-calculator-field.template', '');
    this.destinationTarget.appendChild(clone);
  }

  cloneToDestinationWithFirstNumberIncremented() {
    this.cloneToDestination();

    AddBusinessCalculatorFieldController
      .incrementFirstNumber(this.templateTarget.firstElementChild);
  }

  cloneToDestinationWithSecondNumberIncremented() {
    this.cloneToDestination();

    AddBusinessCalculatorFieldController
      .incrementLastNumber(this.templateTarget.firstElementChild);
  }

  static incrementFirstNumber(element) {
    const newId = AddBusinessCalculatorFieldController
      .incrementFirstIntegerOfArray(element.id.split('_')).join('_');
    element.id = newId;

    const newName = AddBusinessCalculatorFieldController
      .incrementFirstIntegerOfArray(element.name.split('][')).join('][');
    element.name = newName;
  }

  static incrementLastNumber(element) {
    const newId = AddBusinessCalculatorFieldController
      .incrementLastIntegerOfArray(element.id.split('_')).join('_');
    element.id = newId;

    const newName = AddBusinessCalculatorFieldController
      .incrementLastIntegerOfArray(element.name.split('][')).join('][');
    element.name = newName;
  }

  static incrementFirstIntegerOfArray(array) {
    const indexToIncrement = array.findIndex((a) => Number.isInteger(Number(a)));
    array[indexToIncrement] = String(Number(array[indexToIncrement]) + 1);
    return array;
  }

  static incrementLastIntegerOfArray(array) {
    const newArray = AddBusinessCalculatorFieldController
      .incrementFirstIntegerOfArray(array.reverse()).reverse();
    return newArray;
  }
}

AddBusinessCalculatorFieldController.targets = ['template', 'destination'];
