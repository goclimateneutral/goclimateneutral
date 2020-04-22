import { Controller } from 'stimulus';
import submitForm from '../../util/submit_form';

export default class LifestyleCalculatorPreviewController extends Controller {
  calculate(event) {
    event.preventDefault();

    submitForm(this.element)
      .then((response) => response.json())
      .then((data) => {
        if (data.error !== undefined) {
          this.errorTarget.innerText = data.error;
          this.clearResults();

          return;
        }

        this.errorTarget.innerText = '';
        this.setResults(data);
      });
  }

  setResults(data) {
    this.housingResultTarget.innerText = data.housing;
    this.foodResultTarget.innerText = data.food;
    this.carResultTarget.innerText = data.car;
    this.flightsResultTarget.innerText = data.flights;
    this.consumptionResultTarget.innerText = data.consumption;
    this.publicResultTarget.innerText = data.public;
    this.totalTarget.innerText = data.total;
    this.priceTarget.innerText = data.price;
  }

  clearResults() {
    this.housingResultTarget.innerText = '-';
    this.foodResultTarget.innerText = '-';
    this.carResultTarget.innerText = '-';
    this.flightsResultTarget.innerText = '-';
    this.consumptionResultTarget.innerText = '-';
    this.publicResultTarget.innerText = '-';
    this.totalTarget.innerText = '-';
    this.priceTarget.innerText = '-';
  }
}

LifestyleCalculatorPreviewController.targets = ['housingResult', 'foodResult', 'carResult', 'flightsResult', 'consumptionResult', 'publicResult', 'total', 'price', 'error'];
