import { Controller } from 'stimulus';

export default class HeaderController extends Controller {
  initialize() {
    this.isOpen = false;
  }

  toggle() {
    if (this.isOpen) {
      // this.menuTarget.style.height = '0px';
      this.menuTarget.style.maxHeight = '0px';
    } else {
      // this.menuTarget.style.height = `${this.menuTarget.scrollHeight}px`;
      this.menuTarget.style.maxHeight = `${this.menuTarget.scrollHeight}px`;
      // this.menuTarget.style.height = `auto`;
    }
    this.isOpen = !this.isOpen;
  }
}

HeaderController.targets = ['menu'];
