/* eslint-disable import/first */

/* Polyfills */
import 'whatwg-fetch';
import 'core-js/features/promise';

/* Polyfills for Stimulus */
import 'core-js/features/array';
import 'core-js/features/map';
import 'core-js/features/object/assign';
import 'core-js/features/set';
import 'element-closest';
import 'mutation-observer-inner-html-shim';
import 'eventlistener-polyfill';

/* Rails UJS */
import Rails from '@rails/ujs';

Rails.start();

/* Stimulus */
import { Application } from 'stimulus';
import { definitionsFromContext } from 'stimulus/webpack-helpers';

const application = Application.start();
application.load(definitionsFromContext(
  require.context('../shared/controllers', true, /\.js$/)
));
application.load(definitionsFromContext(
  require.context('../main/controllers', true, /\.js$/)
));

/* Bootstrap and inline jQuery calls require jQuery globally */
import jQuery from 'jquery';

window.jQuery = jQuery;
window.$ = jQuery;

/* Font Awesome */
import 'font-awesome/scss/font-awesome.scss';

/* Styling */
import '../main/index.scss';

/* Components */
import '../javascripts/components/business_offset_calculator';
import '../javascripts/components/counting_number';
import '../javascripts/components/projects_map_marker';
import '../javascripts/dashboard';
import '../javascripts/users';
import '../javascripts/users/edit_user';
