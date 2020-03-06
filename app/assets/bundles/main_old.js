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
const context = require.context('../javascripts/controllers', true, /\.js$/);
application.load(definitionsFromContext(context));

/* Bootstrap and inline jQuery calls require jQuery globally */
import jQuery from 'jquery';

window.jQuery = jQuery;
window.$ = jQuery;

/* Font Awesome */
import 'font-awesome/scss/font-awesome.scss';

/* Bootstrap */
import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap';

/* Social Buttons for Bootstrap */
import 'bootstrap-social/bootstrap-social.css';

/* Global styling */
import '../stylesheets/base.scss';
import '../stylesheets/type.scss';
import '../stylesheets/panels.scss';
import '../stylesheets/forms.scss';
import '../stylesheets/layout/content_section.scss';
import '../stylesheets/components/climate_report_table.scss';
import '../stylesheets/components/impact_calculator_fields.scss';
import '../stylesheets/components/navbar_goclimateneutral.scss';
import '../stylesheets/components/gift_cards_intro.scss';
import '../stylesheets/components/registrations_signup_form.scss';
import '../stylesheets/components/business_offset_form.scss';
import '../stylesheets/components/receipts.scss';
import '../stylesheets/components/flight_offset_details.scss';
import '../stylesheets/components/projects_teaser.scss';
import '../stylesheets/components/projects_map.scss';
import '../stylesheets/components/projects_list_item.scss';
import '../stylesheets/components/region_recommendation.scss';
import '../stylesheets/components/tonnes_label.scss';

/* Components */
import '../javascripts/components/business_offset_calculator';
import '../javascripts/components/counting_number';
import '../javascripts/components/projects_map_marker';
import '../javascripts/welcome';
import '../javascripts/dashboard';
import '../javascripts/users';
import '../javascripts/users/edit_card';
import '../javascripts/users/edit_user';
