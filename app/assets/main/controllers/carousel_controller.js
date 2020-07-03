import { Controller } from 'stimulus';
import { swapToActiveClassList, swapToInactiveClassList } from '../../util/swap_classes';

const TIME_TO_NEXT_SLIDE_MS = 6000;

export default class CarouselController extends Controller {
  initialize() {
    this.currentIndex = 0;
    swapToActiveClassList(this.slideTargets[this.currentIndex]);
    swapToActiveClassList(this.slideIndicatorTargets[this.currentIndex]);
    this.nextSlideTimer = this.startTimerUntilNextSlide();
  }

  next() {
    this.goToSlide(this.currentIndex + 1);
  }

  previous() {
    this.goToSlide(this.currentIndex - 1);
  }

  jumpToSlide(element) {
    if (Number.isInteger(Number(element.target.dataset.index))) {
      this.goToSlide(Number(element.target.dataset.index));
    }
  }

  goToSlide(index) {
    if (index === this.currentIndex) {
      return;
    }

    clearTimeout(this.nextSlideTimer);

    let newIndex = index;
    if (index > this.slideTargets.length - 1) {
      newIndex = 0;
    } else if (index < 0) {
      newIndex = this.slideTargets.length - 1;
    }

    swapToInactiveClassList(this.slideTargets[this.currentIndex]);
    swapToInactiveClassList(this.slideIndicatorTargets[this.currentIndex]);
    swapToActiveClassList(this.slideTargets[newIndex]);
    swapToActiveClassList(this.slideIndicatorTargets[newIndex]);
    this.currentIndex = newIndex;

    this.nextSlideTimer = this.startTimerUntilNextSlide();
  }

  startTimerUntilNextSlide() {
    return setTimeout(() => this.next(), TIME_TO_NEXT_SLIDE_MS);
  }
}

CarouselController.targets = ['slide', 'slideIndicator'];
