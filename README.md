# GoClimateNeutral

[![Maintainability](https://api.codeclimate.com/v1/badges/711e900ab6fb4c385a19/maintainability)](https://codeclimate.com/repos/5c99da9af52fd70240006af8/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/711e900ab6fb4c385a19/test_coverage)](https://codeclimate.com/repos/5c99da9af52fd70240006af8/test_coverage) [![View performance data on Skylight](https://badges.skylight.io/typical/zdRSFyrfwutu.svg?token=94hHNP2Fy3Obgt0c3MoiPXDLiIW1E9axYM5e-vN-occ)](https://www.skylight.io/app/applications/zdRSFyrfwutu) [![View performance data on Skylight](https://badges.skylight.io/problem/zdRSFyrfwutu.svg?token=94hHNP2Fy3Obgt0c3MoiPXDLiIW1E9axYM5e-vN-occ)](https://www.skylight.io/app/applications/zdRSFyrfwutu)

This is the code that runs [http://goclimateneutral.org](http://goclimateneutral.org)

## What the app does

GoClimateNeutral makes it easy for everyone to take meaningful action for the
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
- Please share any product ideas with us at info@goclimateneutral.org. We keep
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
| `LifestyleChoice`     | Footprint for an individuals full lifestyle.        |
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

## Getting started

### Requirements

* Ruby and bundler (see `.ruby-version`)
* PostgreSQL
* Firefox and geckodriver

### Setup

* Install dependencies. 
  * [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/).
    See `.ruby-version` for required version.
  * `gem install bundler`
    * Note that this will also install native dependency `wkhtmltopdf` (a binary needed for PDF generation). See Gemfile.
  * `brew install postgresql geckodriver` 
  * [Get Firefox](https://www.mozilla.org/en-US/firefox/)
* Setup the database
  * `initdb db/goclimateneutral`
  * `pg_ctl -D db/goclimateneutral -l logfile start`
* Set environment variables.
  * Copy `.env.sample` to `.env` and add your keys to the file. You will at least need to set the 2 keys for Stripe to get the tests passing.
* Run the setup command that installs project-specific dependencies.
  * `bin/setup`

## Developing

* Run the development server: `bin/rails server`
* If you're doing front-end work, Webpack dev server gives you hot realoding of JS & CSS: `bin/yarn dev`
* Watch for updates and continuosly run relevant specs & linters: `bin/guard`
* Run Ruby tests: `bin/rspec`
* Run Ruby linter: `bin/rubocop`

## Troubleshooting

### Reseting your database

If you need to reset your database:

* Clear lifestyle choices and projects and reset their pk sequences:

  ```ruby
  LifestyleChoice.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!('lifestyle_choices')
  Project.delete_all
  ActiveRecord::Base.connection.reset_pk_sequence!('projects')
  ```

* Re-run `bin/rails db:seed`

### Stopping a hung development server

* `lsof -i :3000`
* Kill the process

## License

All source code and assets are © GoClimateNeutral. All rights reserved.

We are considering opening up our source code with an open source license, but
have not yet found the right license. If you have any experience or
suggestions, please open an issue.
