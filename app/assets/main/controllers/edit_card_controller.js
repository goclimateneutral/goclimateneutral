import { Controller } from 'stimulus';
import { swapToActiveClassList } from '../../util/swap_classes';

export default class EditCardController extends Controller {
  addNewCard() {
    swapToActiveClassList(this.newCardTarget);
  }
}

EditCardController.targets = ['newCard'];
