import { Controller } from 'stimulus';
import { swapToActiveClassList, swapToInactiveClassList } from '../../util/swap_classes';

export default class MembershipChoiceController extends Controller {
  initialize() {
    // Set initial choice, handling that Firefox saves choice on reload
    this.membership = 'single';
    const initialChoice = this.choiceTargets.find((t) => t.value === this.membership);
    initialChoice.checked = true;
  }

  handleChange(event) {
    const newMembership = event.target.value;
    this.change(newMembership);
  }

  // This is needed because changing number of people should
  // automatically make you choose 'multi'
  chooseMulti() {
    this.change('multi');
  }

  change(membership) {
    this.membership = membership;
    if (!['free', 'single', 'multi'].includes(this.membership)) {
      return;
    }
    this.membershipFieldTarget.value = this.membership;
    this.choiceTargets.forEach((target) => {
      if (target.value === this.membership) {
        MembershipChoiceController.activateChoice(target);
      } else {
        MembershipChoiceController.deactivateChoice(target);
      }
    });
    if (this.membership === 'free') {
      swapToInactiveClassList(this.stripeCardElementTarget);
      this.showNoSubscriptionInfo();
    } else {
      this.registrationPriceController.update();
      swapToActiveClassList(this.stripeCardElementTarget);
      this.showSubscriptionInfo();
    }
  }

  showSubscriptionInfo() {
    this.noSubscriptionInfoTargets.forEach((target) => {
      swapToInactiveClassList(target);
    });
    this.subscriptionInfoTargets.forEach((target) => {
      swapToActiveClassList(target);
    });
  }

  showNoSubscriptionInfo() {
    this.noSubscriptionInfoTargets.forEach((target) => {
      swapToActiveClassList(target);
    });
    this.subscriptionInfoTargets.forEach((target) => {
      swapToInactiveClassList(target);
    });
  }

  get registrationPriceController() {
    return this.application.getControllerForElementAndIdentifier(this.priceControllerElementTarget, 'registration-price');
  }
}

MembershipChoiceController.activateChoice = function activateChoice(target) {
  swapToActiveClassList(target.parentNode);
  if (!target.checked) {
    target.checked = true;
  }
};

MembershipChoiceController.deactivateChoice = function deactivateChoice(target) {
  swapToInactiveClassList(target.parentNode);
  if (target.checked) {
    target.checked = false;
  }
};

MembershipChoiceController.targets = ['priceControllerElement', 'choice', 'membershipField', 'subscriptionInfo', 'noSubscriptionInfo', 'stripeCardElement'];
