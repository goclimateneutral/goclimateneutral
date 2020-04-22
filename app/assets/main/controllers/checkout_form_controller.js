import { Controller } from 'stimulus';
import submitForm from '../../util/submit_form';

export default class CheckoutFormController extends Controller {
  initialize() {
    this.loading = false;
  }

  submit(event) {
    event.preventDefault();

    if (!this.stripeCardElementController.complete) {
      this.setErrorMessage('Please complete your card details.');
      return;
    }

    this.enableLoadingState();
    this.setErrorMessage('');

    submitForm(this.element)
      .then((response) => response.json())
      .then((data) => this.resolveFormResponse(data))
      .catch((error) => {
        window.Sentry.captureException(error); // These errors are unexpected, so report them.
        this.setErrorMessage('An unexpected error occurred. Please start over and try again. If the issue remains, please contact us at info@goclimateneutral.org.');
      })
      .finally(() => {
        this.disableLoadingState();
      });
  }

  resolveFormResponse(data) {
    return new Promise((resolve) => {
      if (data.error !== undefined) {
        this.setErrorMessage(data.error.message);
        resolve();
        return;
      }

      window.stripe.confirmCardPayment(
        data.payment_intent_client_secret,
        { payment_method: { card: this.stripeCardElementController.cardElement } }
      )
        .then((result) => {
          if (result.paymentIntent !== undefined) {
            window.location = data.success_url;
          } else {
            this.setErrorMessage(result.error.message);
          }
          resolve();
        });
    });
  }

  setErrorMessage(errorMessage) {
    this.errorMessageTarget.innerText = errorMessage;
  }

  enableLoadingState() {
    this.loadingIndicatorTarget.classList.remove('hidden');
    this.submitButtonTarget.disabled = true;
  }

  disableLoadingState() {
    this.loadingIndicatorTarget.classList.add('hidden');
    this.submitButtonTarget.disabled = false;
  }

  get stripeCardElementController() {
    return this.application.getControllerForElementAndIdentifier(this.stripeCardElementTarget, 'stripe-card-element');
  }
}

CheckoutFormController.targets = ['submitButton', 'stripeCardElement', 'errorMessage', 'loadingIndicator'];
