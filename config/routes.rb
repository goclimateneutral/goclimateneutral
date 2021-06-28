# frozen_string_literal: true

Rails.application.routes.draw do
  # Handle legacy locale subdomains. Doing this in Cloudflare requires a paid
  # account for the extra page rules which we currently want to avoid.
  match '(*path)', to: redirect { |_, request| "//www.goclimate.com/se#{request.fullpath}" },
                   via: [:get, :post], constraints: { host: 'sv.goclimateneutral.org' }
  match '(*path)', to: redirect { |_, request| "//www.goclimate.com/de#{request.fullpath}" },
                   via: [:get, :post], constraints: { host: 'de.goclimateneutral.org' }
  match '(*path)', to: redirect { |_, request| "//www.goclimate.com/us#{request.fullpath}" },
                   via: [:get, :post], constraints: { host: 'en.goclimateneutral.org' }

  # API. Available on subdomain `api.` in production and under path `/api` in other environments.
  api = proc do
    namespace 'api', path: '', defaults: { subdomain: ENV['HEROKU_ENV'] == 'production' ? 'api' : false } do
      namespace 'v1', defaults: { format: :json }, constraints: { format: :json } do
        match '*path', via: [:options], to: 'api#cors_preflight', as: nil
        resource :flight_footprint, only: [:show]
      end

      resource :documentations, only: [:show], path: 'docs'
      resources :api_keys, only: [:new, :create], path_names: { new: '' }
    end

    # Other routes should not match for the api subdomain, so catch everything
    # else and return not found. This only makes a difference in production
    # where the subdomain is actually used.
    match '/', to: 'errors#not_found', via: :all
    match '*path', to: 'errors#not_found', via: :all
  end
  ENV['HEROKU_ENV'] == 'production' ? constraints(subdomain: /api|api-temporary/, &api) : scope('/api', &api)

  # Redirect any other domain to our main one in production. Since we're
  # catching all potential domains, do a temporary redirect as to not
  # accidentally cache redirects for domains we're migrating to or
  # similar. Subdomains of the primary domains are also not caught.
  if ENV['HEROKU_ENV'] == 'production'
    match '(*path)', to: redirect { |_, request| "//www.goclimate.com#{request.fullpath}" },
                     via: [:get, :post], constraints: ->(req) { !req.host.include?('goclimate.com') }
  end

  # Public site
  scope '(:region)', region: Regexp.new(Region.all.map(&:slug).compact.join('|')) do
    root 'home#show'

    # Devise routes for sessions, registrations & payment
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }
    namespace :users, as: 'user' do
      resource :subscription, only: [:show, :update, :destroy]
      resources :receipts, only: [:index, :show], param: :card_charge_id
    end

    # Content pages
    resource :about, controller: 'about', only: [:show]
    resource :contact, controller: 'about/contact', only: [:show]
    resource :cookies, controller: 'about/cookies', only: [:show]
    resource :faq, controller: 'about/faq', only: [:show]
    resource :transparency, controller: 'about/transparency', only: [:show]
    resource :privacy_policy, controller: 'about/privacy_policy', path: 'privacy-policy', only: [:show]
    resource :travel_calculator, controller: 'travel_calculator', path: 'travel-calculator', only: [:show]
    resource :price_increase_confirmation, controller: 'price_increase_confirmation', path: 'price-increase', only: [:new, :create], path_names: { new: '' } do
      member do
        post :opt_in
        post :opt_out
        get 'thank-you'
      end
    end
    resource :climate_tips, path: 'climate-tips', only: [:show]
    resource :take_action, controller: 'take_action', path: 'take-action', only: [:show]

    resources :lifestyle_footprints, path: 'calculator', only: [:new, :create], path_names: { new: '' } do
      collection do
        resources :lifestyle_footprints, path: 'results', only: [:index, :show, :destroy]
      end
    end

    resources :referral_codes, path: 'referral-codes', only: [] do
      collection do
        post :lookup
      end
    end

    resources :data_reporters, path: 'data-reporters', only: [:show]
    resources :reported_datas, path: 'report-data', only: [:new, :create, :update], path_names: { new: '' } do
      member do
        get 'thank-you'
        get 'preview'
      end
    end

    resources :projects, path: 'climate-projects', only: [:index]

    resource :know_your_footprint, controller: 'know_your_footprint', path: 'know-your-carbon-footprint', only: [:show]
    get '/knowyourcarbonfootprint', to: redirect('know-your-carbon-footprint')
    get '/KnowYourCarbonFootprint', to: redirect('know-your-carbon-footprint')

    namespace :business do
      root 'home#show'

      resource :advisory, controller: 'advisory', only: [:show]
      resource :offsetting, controller: 'offsetting', only: [:show]

      resources :climate_reports, path: 'climate-reports', only: [:index, :show, :new, :create], param: :key do
        member do
          resource :climate_report_invoice, only: [:create], path: 'invoice' do
            get 'thank-you'
          end
        end
        scope format: true, constraints: { format: :pdf } do
          get 'pdf'
        end
      end

      # Business page with post from employee offsetting form
      resource :contact, only: [:new, :create], path_names: { new: '' }
    end

    # Partners
    get 'partners/bokanerja'
    get 'partners/inshapetravel'
    get 'partners/flygcity'

    # Flight one time offsets
    resources :flight_footprints, path: 'flights', only: [:new, :create], path_names: { new: '' } do
      collection do
        resources :airport_suggestions, only: [:index], format: true, constraints: { format: :json }
      end
    end
    resources :flight_offsets, only: [:index, :new, :create], param: :key do
      member do
        get 'thank-you'
        scope format: true, constraints: { format: :pdf } do
          resource :flight_offset_certificates, only: [:show], path: :certificate
          resource :flight_offset_receipts, only: [:show], path: :receipt
        end
      end
    end

    # Dashboard
    resource :dashboard, controller: 'dashboard', only: [:show]

    # User profiles
    resources :users, only: [:show], constraints: { id: /\d+/ }

    # Gift cards
    resources :gift_cards, path: 'gift-cards', only: [:index, :new, :create], param: :key do
      collection do
        get 'example/certificate', to: 'gift_card_certificates#example', format: true, constraints: { format: :pdf }
      end

      member do
        get 'thank-you'

        scope format: true, constraints: { format: :pdf } do
          resource :gift_card_certificates, only: [:show], path: :certificate
          resource :gift_card_receipts, only: [:show], path: :receipt
        end
      end
    end

    resources :newsletter_subscribers, only: [:create]

    # Assets that users may download
    get '/assets', to: redirect(status: 302) {
      'https://drive.google.com/drive/folders/1YN6Vomjkrp-eFZYonZehELbjz1x8BkL_?usp=sharing'
    }

    # Redirects for old routes. To avoid broken links on the internet, don't remove these.
    defaults region: nil do
      get 'klimatkompensera', to: redirect('%{region}/'), as: nil
      get 'friendlyguide', to: redirect('%{region}/'), as: nil
      get 'gift_cards/thank_you', as: nil, to: redirect(status: 302) { |path_params, request|
        raise ActionController::RoutingError, 'Not Found' unless request.flash[:certificate_key].present?

        "#{path_params[:region]}/gift-cards/#{request.flash[:certificate_key]}/thank-you"
      }
      get 'dashboard/index', to: redirect('%{region}/dashboard'), as: nil
      get '/users', to: redirect('%{region}/dashboard'), as: nil
      get '/users/edit/payment', to: redirect('%{region}/users/subscription'), as: nil
      get 'companies', to: redirect('%{region}/business'), as: nil
      get 'business_beta', to: redirect('%{region}/business'), as: nil
      get '100_percent_transparency', to: redirect('%{region}/transparency'), as: nil
      get 'travel_calculator', to: redirect('%{region}/travel-calculator'), as: nil
      get 'our_projects', to: redirect('%{region}/climate-projects'), as: nil
      get 'gift_cards', to: redirect(path: '%{region}/gift-cards'), as: nil
      get 'gift_cards/new', to: redirect(path: '%{region}/gift-cards/new'), as: nil
      get 'gift_cards/certificates/example', to: redirect(path: '%{region}/gift-cards/example/certificate.pdf'), as: nil
      get 'gift_cards/certificates/:key', to: redirect(path: '%{region}/gift-cards/%{key}/certificate.pdf'), as: nil
      get 'gift_cards/:key/thank_you', to: redirect(path: '%{region}/gift-cards/%{key}/thank-you'), as: nil
      get 'business/climate_reports/:key', to: redirect(path: '%{region}/business/climate-reports/%{key}'), as: nil
      get 'business/climate_reports/new', to: redirect(path: '%{region}/business/climate-reports/new'), as: nil
      get 'business/climate_reports/:key/invoice/thank_you',
          to: redirect(
            path: '%{region}/business/climate-reports/%{key}/invoice/thank-you'
          ), as: nil
      get 'Jo', to: redirect('%{region}/'), as: nil # Invalid URL accidentally shared by The YIKES Podcast
    end
  end

  namespace :webhooks do
    resource :stripe_events, only: [:create]
  end

  # Admin
  namespace :admin do
    root to: 'dashboard#index'
    resources :api_keys
    resources :referral_codes
    resources :business_calculators, only: [:index, :show, :new, :edit, :create, :update] do
      member do
        post :publish
        post :archive
        post :duplicate
      end
    end
    resources :organizations
    resources :units
    resources :climate_reports do
      member do
        get :preview
      end
    end
    resources :data_requests
    resources :data_reporters
    resources :reported_datas, only: [:index, :show, :destroy] do
      collection do
        get :export_to_csv
      end
    end
    resources :invoices
    resources :lifestyle_calculators, only: [:index, :show, :new, :create] do
      member do
        resource :lifestyle_calculator_preview, path: :preview, only: [:create]
        get :review, path: :publish
        post :publish
      end
    end
    resources :projects
    resources :flight_offsets, only: [:index, :show, :new, :create]
    resources :climate_report_invoices, only: [:index, :show, :edit, :update]
    resource :invoice_certificates, only: [:show], format: true, constraints: { format: :pdf }
    resource :invoice_certificates, only: [] do
      post 'send_email', on: :collection
    end
    resource :flight_batch, controller: 'flight_batch', only: [:new, :create]
    post '/refresh_instagram_token', to: 'dashboard#refresh_instagram_token'
  end

  # Errors
  match '/404', to: 'errors#not_found', via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  # Vanity URL redirects
  get '/blog', to: redirect('https://www.goclimate.com/blog/'), as: nil

  # Sitemap xml
  get '/sitemap.xml' => 'sitemap#index', :format => 'xml', :as => :sitemap
  get '/sitemap_content.xml' => 'sitemap#content', :format => 'xml', :as => :sitemap_content

  # Catch all routes
  get ':code', to: 'referral_codes#show',
               constraints: ->(req) { Subscriptions::ReferralCode.exists?(code: req.params[:code]) }
end
