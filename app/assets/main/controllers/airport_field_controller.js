import { Controller } from 'stimulus';
import { swapToActiveClassList, swapToInactiveClassList } from '../../util/swap_classes';

export default class AirportFieldController extends Controller {
  initialize() {
    this.focusedAirportIndex = null;
    this.requestPending = false;
    this.requestedWhilePending = false;
  }

  search() {
    if (this.requestPending) {
      this.requestedWhilePending = true;
      return;
    }

    this.airportCodeFieldTarget.value = '';

    if (this.searchFieldTarget.value.length < 2) {
      this.closeSuggestionsDropdown();
      return;
    }

    this.requestPending = true;
    const searchUrl = `${this.element.dataset.searchEndpoint}?q=${encodeURI(this.searchFieldTarget.value)}`;
    fetch(searchUrl, { credentials: 'include' })
      .then((response) => response.json())
      .then((data) => {
        this.presentAirportSuggestions(data.suggestions);
      })
      .finally(() => {
        this.requestPending = false;

        if (this.requestedWhilePending) {
          this.requestedWhilePending = false;
          this.search();
        }
      });
  }

  select() {
    const focusedListItem = this.focusedListItem();

    if (
      focusedListItem !== undefined
      && focusedListItem.dataset.iataCode !== undefined
      && focusedListItem.dataset.name !== undefined
    ) {
      this.airportCodeFieldTarget.value = focusedListItem.dataset.iataCode;
      this.searchFieldTarget.value = focusedListItem.dataset.name;
    }

    this.closeSuggestionsDropdown();
  }

  keyboardNavigate(event) {
    if (!(event.keyCode === 38 || event.keyCode === 40 || event.keyCode === 13)) {
      return;
    }

    event.preventDefault();

    switch (event.keyCode) {
      case 38:
        this.focusPrevious();
        break;
      case 40:
        this.focusNext();
        break;
      case 13:
        this.select();
        break;
      default:
    }
  }

  focusPrevious() {
    let previousItemIndex = this.focusedAirportIndex - 1;

    if (previousItemIndex < 0) {
      previousItemIndex = this.suggestionsListTarget.childNodes.length - 1;
    }

    this.focusAirportAtIndex(previousItemIndex);
  }

  focusNext() {
    let nextItemIndex = this.focusedAirportIndex + 1;

    if (nextItemIndex >= this.suggestionsListTarget.childNodes.length) {
      nextItemIndex = 0;
    }

    this.focusAirportAtIndex(nextItemIndex);
  }

  presentAirportSuggestions(airportSuggestions) {
    this.suggestionsListTarget.textContent = '';

    if (airportSuggestions.length > 0) {
      airportSuggestions.forEach((airport, index) => {
        this.suggestionsListTarget.appendChild(
          this.createListItem(airport, index)
        );
      });
      this.focusAirportAtIndex(0);
    } else {
      this.suggestionsListTarget.appendChild(this.createNoResultsItem());
    }

    this.openSuggestionsDropdown();
  }

  openSuggestionsDropdown() {
    swapToActiveClassList(this.dropdownTriggerTarget);
  }

  closeSuggestionsDropdown() {
    this.suggestionsListTarget.textContent = '';
    swapToInactiveClassList(this.dropdownTriggerTarget);
  }

  focusAirportAtIndex(index) {
    this.focusedAirportIndex = index;

    this.suggestionsListTarget.childNodes.forEach((element) => {
      element.classList.remove('active');
    });

    this.suggestionsListTarget.childNodes[this.focusedAirportIndex].classList.add('active');
  }

  focusedListItem() {
    return this.suggestionsListTarget.childNodes[this.focusedAirportIndex];
  }

  createListItem(airport, index) {
    const listItem = document.createElement('li');
    const link = document.createElement('a');
    listItem.appendChild(link);

    listItem.dataset.iataCode = airport.iata_code;
    listItem.dataset.name = airport.name;

    link.innerText = airport.name;

    listItem.addEventListener('mouseover', () => {
      this.focusAirportAtIndex(index);
    });

    listItem.addEventListener('click', () => {
      this.focusAirportAtIndex(index);
      this.select();
    });

    return listItem;
  }

  createNoResultsItem() { // eslint-disable-line class-methods-use-this
    const listItem = document.createElement('li');
    const text = document.createElement('a');
    listItem.appendChild(text);

    text.innerText = 'No results';

    return listItem;
  }

  remove() {
    this.containerTarget.parentNode.removeChild(this.containerTarget);
  }
}

AirportFieldController.targets = ['container', 'dropdownContainer', 'suggestionsList', 'searchField', 'airportCodeField', 'dropdownTrigger'];
