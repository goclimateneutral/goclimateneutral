import { Controller } from 'stimulus';

export default class HeaderController extends Controller {
  initialize() {
    this.isOpen = false;
  }

  toggle() {
    if (this.isOpen) {
      this.menuTarget.classList.add('max-h-0');
      this.menuTarget.classList.remove('max-h-screen');
    } else {
      this.menuTarget.classList.remove('max-h-0');
      this.menuTarget.classList.add('max-h-screen');
    }
    this.isOpen = !this.isOpen;
  }
}

HeaderController.targets = ['menu'];
