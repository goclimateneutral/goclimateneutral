import { Controller } from 'stimulus';

export default class LifestyleFootprintController extends Controller {
  initialize() {
    this.currentQuestionIndex = 0;
    this.currentCategoryIndex = 0;
    this.showQuestion(this.currentQuestionIndex);
    this.setStepToActive(this.currentQuestionIndex);
    this.setCategoryToActive(this.currentQuestionIndex);
    this.hideBackButton(this.currentQuestionIndex);
  }

  showQuestion(id) {
    this.questionsTargets[id].classList.remove('hidden');
  }

  hideQuestion(id) {
    this.questionsTargets[id].classList.add('hidden');
  }

  setStepToActive(id) {
    this.stepsTargets[id].classList.remove('fa-circle-o');
    this.stepsTargets[id].classList.add('fa-circle');
    this.stepsTargets[id].classList.add('text-bootstrap-green-500');
  }

  setStepToIdle(id) {
    this.stepsTargets[id].classList.remove('fa-circle');
    this.stepsTargets[id].classList.add('fa-circle-o');
    this.stepsTargets[id].classList.remove('text-bootstrap-green-500');
  }

  setCategoryToActive(id) {
    this.categoriesTargets[id].classList.add('text-bootstrap-green-500');
  }

  setCategoryToIdle(id) {
    this.categoriesTargets[id].classList.remove('text-bootstrap-green-500');
  }

  hideBackButton() {
    this.backTarget.classList.add('hidden');
  }

  showBackButton() {
    this.backTarget.classList.remove('hidden');
  }

  goToIndex(index) {
    const steps = index - this.currentQuestionIndex;
    const direction = steps / Math.abs(steps);
    this.currentQuestionIndex = index;
    this.hideQuestion(this.currentQuestionIndex - steps);
    this.setStepToIdle(this.currentQuestionIndex - steps);
    this.setStepToActive(this.currentQuestionIndex);
    this.showQuestion(this.currentQuestionIndex);
    if (this.currentQuestionIndex > 0) {
      this.showBackButton();
    } else {
      this.hideBackButton();
    }

    let categorySteps = 0;
    for (let i = 0; i < Math.abs(steps); i += 1) {
      if (
        this.stepsTargets[this.currentQuestionIndex - direction].dataset.category
        !== this.stepsTargets[this.currentQuestionIndex - i * direction].dataset.category
      ) {
        categorySteps += 1;
      }
    }
    this.setCategoryToIdle(this.currentCategoryIndex);
    this.currentCategoryIndex += categorySteps * direction;
    this.setCategoryToActive(this.currentCategoryIndex);
  }

  nextQuestion(e) {
    e.preventDefault();
    this.goToIndex(this.currentQuestionIndex + 1);
  }

  previousQuestion(e) {
    e.preventDefault();
    this.goToIndex(this.currentQuestionIndex - 1);
  }

  skipNextQuestion(e) {
    e.preventDefault();
    this.goToIndex(this.currentQuestionIndex + 2);
  }
}

LifestyleFootprintController.targets = ['questions', 'steps', 'categories', 'back'];
