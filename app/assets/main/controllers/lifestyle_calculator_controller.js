/* eslint no-param-reassign: 'off' */

import { Controller } from 'stimulus';
import { swapToActiveClassList, swapToInactiveClassList } from '../../util/swap_classes';

export default class LifestyleCalculatorController extends Controller {
  initialize() {
    this.groupedTargets = this.groupTargets();

    if (this.currentCategoryIndex() === undefined || this.currentQuestioIndex() === undefined) {
      this.goToQuestion(0, 0);
    }
  }

  nextQuestion() {
    let nextCategoryIndex = this.currentCategoryIndex();
    let nextQuestionIndex = this.currentQuestionIndex() + 1;

    if (nextQuestionIndex >= this.groupedTargets[nextCategoryIndex].questions.length) {
      nextCategoryIndex += 1;
      nextQuestionIndex = 0;
    }

    this.goToQuestion(nextCategoryIndex, nextQuestionIndex);
  }

  nextCategory() {
    const nextCategoryIndex = this.currentCategoryIndex() + 1;

    this.goToQuestion(nextCategoryIndex, 0);
  }

  previousCategory() {
    let nextCategoryIndex = this.currentCategoryIndex() - 1;

    if (nextCategoryIndex < 0) { nextCategoryIndex = 0; }

    this.goToQuestion(nextCategoryIndex, 0);
  }

  goToQuestion(categoryIndex, questionIndex) {
    const currentCategoryIndex = this.currentCategoryIndex();
    const currentQuestionIndex = this.currentQuestionIndex();

    if (currentCategoryIndex !== categoryIndex) {
      if (currentCategoryIndex !== undefined) {
        swapToInactiveClassList(this.groupedTargets[currentCategoryIndex].categoryIndicator);
      }

      swapToActiveClassList(this.groupedTargets[categoryIndex].categoryIndicator);
    }

    if (currentCategoryIndex !== categoryIndex || currentQuestionIndex !== questionIndex) {
      if (currentQuestionIndex !== undefined) {
        swapToInactiveClassList(
          this.groupedTargets[currentCategoryIndex].questionIndicators[currentQuestionIndex]
        );
        this.groupedTargets[currentCategoryIndex].questions[currentQuestionIndex].classList.add('hidden');
      }

      swapToActiveClassList(
        this.groupedTargets[categoryIndex].questionIndicators[questionIndex]
      );
      this.groupedTargets[categoryIndex].questions[questionIndex].classList.remove('hidden');

      if (categoryIndex === 0 && questionIndex === 0) {
        this.backTarget.classList.add('hidden');
      } else if (currentCategoryIndex === 0 && currentQuestionIndex === 0) {
        this.backTarget.classList.remove('hidden');
      }
    }

    this.element.dataset.currentCategory = categoryIndex;
    this.element.dataset.currentQuestion = questionIndex;
  }

  currentCategoryIndex() {
    if (this.element.dataset.currentCategory === undefined) { return undefined; }

    return Number(this.element.dataset.currentCategory);
  }

  currentQuestionIndex() {
    if (this.element.dataset.currentQuestion === undefined) { return undefined; }

    return Number(this.element.dataset.currentQuestion);
  }

  groupTargets() {
    return this.categoryIndicatorTargets.map((c) => ({
      categoryIndicator: c,
      questionIndicators: this.questionIndicatorTargets.filter(
        (q) => (q.dataset.category === c.dataset.category)
      ),
      questions: this.questionTargets.filter(
        (q) => (q.dataset.category === c.dataset.category)
      )
    }));
  }
}

LifestyleCalculatorController.targets = ['categoryIndicator', 'questionIndicator', 'question', 'back'];
