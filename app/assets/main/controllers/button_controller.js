import { Controller } from 'stimulus';

export default class ButtonController extends Controller {
  initialize() {
    this.element.classList.add('button', 'relative');
    const { status } = this.element.dataset;
    let statusIndicator;
    if (status === 'loading') {
      statusIndicator = document.createElement('span');
      statusIndicator.classList.add('absolute', 'left-1/2', 'top-1/2', 'transform', '-translate-x-1/2', '-translate-y-1/2');
      const i = document.createElement('i');
      i.classList.add('fas', 'fa-circle-notch', 'fa-spin');
      statusIndicator.appendChild(i);
      this.element.appendChild(statusIndicator);
      this.contentTarget.classList.add('invisible');
    } else if (status === 'success') {
      console.log("success status");
    }
  }
}

ButtonController.targets = ['content'];
