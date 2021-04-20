# GoClimate

[![Maintainability](https://api.codeclimate.com/v1/badges/711e900ab6fb4c385a19/maintainability)](https://codeclimate.com/repos/5c99da9af52fd70240006af8/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/711e900ab6fb4c385a19/test_coverage)](https://codeclimate.com/repos/5c99da9af52fd70240006af8/test_coverage)

This is the code that runs [http://www.goclimate.com](http://www.goclimate.com)

## What the app does

GoClimate makes it easy for everyone to take meaningful action for the
climate.

## Contributing

Work is primarily focused on reaching outcomes of the theme that our internal
team currently focuses on.

As an external collaborator, we welcome you to open issues or, if you're
proficient in Ruby, work on tech improvments that are marked ready to work on
in GitHub Issues. We ask you to not work on new features without first
coordinating with us, as new features introduce maintenance that we need to
take into account.

### Reporting issues & feature ideas

- Report technical debt and refactorings as issues here on GitHub.
- Please share any product ideas with us at hello@goclimate.com. We keep
  a list of ideas on an internal idea board.

Keep in mind that none of these are "backlogs" in the traditional sense (we
have no backlogs). We only commit to work when we're about to start it and
always select freely from all ideas based on what outcome we currently focus on.

## The domain & models

Our domain consists of:

- Calculators to understand one's footprint in different areas.
- Carbon offset products fit for different use cases.
- Accounts & other supporting models.

### Core concepts

| Model                 | Description                                         |
| ----------------------|-----------------------------------------------------|
| `GreenhouseGases`     | An amount of greenhouse gases, either estimated emissions or offset amount. We use the term `co2e` and always store this in kg's |
| `Project`             | A carbon offsetting project. These are the credits we sell through our products. |
| `Money`               | An amount and a currency. Amounts are stored and processed as smallest units (cents/öres). |
| `Region`              | A named region with a combination of language and currency. Each region corresponds to their own base URL for SEO reasons. (Not yet implemented.) |

### Calculators

| Model                 | Description                                         |
| ----------------------|-----------------------------------------------------|
| `LifestyleFootprint`  | Footprint for an individual's full lifestyle.       |
| `GenericFlightFootprint` | Footprint for flight iteniraries.                |
| (Gift cards)          | (Done inline in `GiftCard`.)                        |
| (Service companies)   | (Done inline in `ClimateReportCalculation`.)        |

### Products

| Model                 | Description                                         |
| ----------------------|-----------------------------------------------------|
| Subscription & related payments (in Stripe) | Monthly subscription for continuously offseting an individuals full lifestyle footprint. |
| `GiftCard`            | A sold gift card.                                   |
| `FlightOffset`        | A sold flight offset.                               |
| `ClimateReportInvoice` | Sold offsetting for a climate report done by a service company. |
| `Invoice`             | Sold offsetting for ad-hoc agreements.              |

### Supporting

| Model                 | Description                                         |
| ----------------------|-----------------------------------------------------|
| `User`                | A registered user. Account creation is currently only possible by signing up for a subscription, but you can cancel and still keep the account. |
| `CardCharge`          | Charges for purchases of an offset product.         |

## Coding guidelines

We follow these principles:

- Start by asking yourself how the problem can be solved without code. Only
  write the code that is necessary.
- Break solutions into small, self-contained increments. This minimizes risk
  and makes it easier for us to reason about changes as a team.
- Write solutions that use no or well-established tools & libraries.  Fewer &
  more stable dependencies reduce our exposure for maintainence costs.
- Push domain logic to models and keep views, controllers, etc as lean as
  possible.
- Aim for good test coverage of domain logic. Keep integration tests focused on
  the happy path.
- Start out with specific implementations, naming, etc and make abstractions
  later. When in doubt, make abstractions when you encounter a third use case,
  not before.
- Optimize logic for readability by making it as straightforward and simple as
  possible. Code will be written once but read multiple times, so it's worth
  spending time to make the implementation simple and easy to understand.

### Commits

Commit often & [write well-formed commit messages that explain why, not
what](https://chris.beams.io/posts/git-commit/).

### Code

Follow linter config (open a PR with rule changes if you disagree) and write
tests according to [Better Specs](http://www.betterspecs.org).

#### Views

When writing HTML views, we write utility-first CSS, using [TailwindCSS](https://tailwindcss.com/), combined with some of our own custom utilities and components. In order to have coherency in the code, these are some conventions we follow:

- Favor Tailwind's [space utilities](https://tailwindcss.com/docs/space/) on parent element before setting margin on children
- Favor our responsive helper classes  before re-inveting the wheel (see `headings` or `section padding` for instance).
- If you are using flexbox for layouting for a specific breakpoint, consider using flexbox across breakpoints instead of mixing with other techniques, such as `mx-auto`

#### Adding localized strings

We use Crowdin for localization. Adding new localized strings requires you to
also add autogenerated placeholder values for those strings in a Crowdin
"pseudo-locale" used for in-context editing of translations (using language
code `eo` in this project). This is done by running: `bin/rails i18n:normalize_crowdin`

#### A/B testing

We have a custom set up for A/B testing. Setting up an A/B test is done in `experiments.yml`. When you have added the feature key name and frequency in `experiments.yml`, you are ready to use it in templates.

```
  <% if experiment_active?(:my_feature) %>
    <!-- some value -->
  <% else %>
    <!-- some other value -->
  <% end %>
```

A/B tests can be manually enabled or disabled with a query string. You can specify multiple tests by separating them with a `,`.

```
enable_experiments=my_feature,my_other_feature
```
```
disable_experiments=my_feature,my_other_feature
```

## Getting started

### Requirements

* Ruby and bundler (see `.ruby-version`)
* PostgreSQL
* Firefox and geckodriver
* For working with localized strings: Crowdin CLI & account (https://support.crowdin.com/cli-tool/)

### Setup

* Install dependencies. 
  * [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/).
    See `.ruby-version` for required version.
  * `gem install bundler`
    * Note that this will also install native dependency `wkhtmltopdf` (a binary needed for PDF generation). See Gemfile.
  * `brew install postgresql geckodriver` 
  * [Get Firefox](https://www.mozilla.org/en-US/firefox/)
* Setup the database
  * `initdb db/goclimate`
  * `pg_ctl -D db/goclimate -l logfile start`
* Set environment variables.
  * Copy `.env.sample` to `.env` and add your keys to the file. You will at least need to set the 2 keys for Stripe to get the tests passing.
* Run the setup command that installs project-specific dependencies.
  * `bin/setup`
* Create your own `.crowdin.yml` in your home directory (i.e. `~/.crowdin.yml`) with your API key found on your account pages on Crowdin:
  * ```yml
    api_token: <your token>
    ```

## Developing

* Run the development server: `bin/rails server`
* If you're doing front-end work, Webpack dev server gives you hot realoding of JS & CSS: `bin/yarn dev`
* Watch for updates and continuosly run relevant specs & linters: `bin/guard`
* Run Ruby tests: `bin/rspec`
* Run Ruby linter: `bin/rubocop`

## Deployment

Deployment is done automatically on pushes to `master` – just merge your changes.

### Deploying database changes

If you are making database changes, you need to manually run them in the Heroku console. Good and safe practise is to keep your migrations into its own commit and deploy separate from the code that is affected by your database changes. The order depends of whether you're adding or removing things from the database. The command to run the migrations is: `heroku run rails db:migrate -a goclimateneutral`.

## Troubleshooting

### Reseting your database

If you need to reset your database:

* Run `bin/rails db:reset`

### Stopping a hung development server

* `lsof -i :3000`
* Kill the process

## License

All source code and assets are © GoClimate Sweden AB. All rights reserved.

We are considering opening up our source code with an open source license, but
have not yet found the right license. If you have any experience or
suggestions, please open an issue.
