import { Controller } from 'stimulus';
import { swapToActiveClassList, swapToInactiveClassList } from '../../util/swap_classes';

export default class MembershipChoiceCampaignController extends Controller {
  showFree() {
    swapToInactiveClassList(this.freeTarget);
    swapToInactiveClassList(this.payingTarget);
    swapToActiveClassList(this.signupFreeTarget);
  }

  showPaying() {
    swapToInactiveClassList(this.freeTarget);
    swapToInactiveClassList(this.payingTarget);
    swapToActiveClassList(this.signupPayingTarget);
  }

  showInitial(event) {
    event.preventDefault();
    swapToActiveClassList(this.freeTarget);
    swapToActiveClassList(this.payingTarget);
    swapToInactiveClassList(this.signupFreeTarget);
    swapToInactiveClassList(this.signupPayingTarget);
  }
}

MembershipChoiceCampaignController.targets = ['free', 'paying', 'signupFree', 'signupPaying', 'membershipField'];
