import { Controller } from 'stimulus';

export default class ModalController extends Controller {
  initialize() {
    this.closeButton = ModalController.createCloseButton();

    ModalController.insertElementFirst(this.closeButton, this.contentTarget);
  }

  static insertElementFirst(element, parent) {
    const theFirstChild = parent.firstChild;
    parent.insertBefore(element, theFirstChild);
  }

  static createCloseButton() {
    const closeButton = document.createElement('button');
    const icon = document.createElement('i');
    const screenReaderFallback = document.createElement('span');

    screenReaderFallback.classList.add('sr-only');
    screenReaderFallback.innerText = 'close';
    icon.classList.add('fa', 'fa-times');
    icon.setAttribute('aria-hidden', 'true');
    icon.appendChild(screenReaderFallback);
    closeButton.classList.add('modal-close-button');
    closeButton.setAttribute('data-action', 'modal#close');
    closeButton.appendChild(icon);

    return closeButton;
  }

  open() {
    this.containerTarget.style.visibility = 'visible';
    this.closeButton.focus();
  }

  close() {
    this.containerTarget.style.visibility = 'hidden';
    this.triggerTarget.focus();
  }
}

ModalController.targets = ['trigger', 'content', 'container'];
