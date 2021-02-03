import { Controller } from 'stimulus';
import React from 'react';
import ReactDOM from 'react-dom';

const componentContext = require.context('../react_components', true, /\.jsx$/);

const components = {};
componentContext.keys().forEach((key) => {
  const component = componentContext(key).default;
  components[component.name] = component;
});

export default class ReactComponentController extends Controller {
  initialize() {
    ReactDOM.render(
      React.createElement(
        components[this.element.dataset['react-component']],
        JSON.parse(this.element.dataset['react-props'])
      ),
      this.element
    );
  }
}
