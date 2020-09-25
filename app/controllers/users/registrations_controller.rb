# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController # rubocop:disable Metrics/ClassLength
    before_action :set_footprint_and_price, only: [:new, :create]
    before_action :set_user, only: [:create]
    before_action :set_subscription_manager, only: [:create]
    skip_before_action :require_no_authentication, only: [:create]

    # GET /resource/sign_up
    def new
      @user = User.new(region: current_region.id)
      @footprint_price = SubscriptionManager.price_for_footprint(@footprint.total, current_region.currency)

      @projects = Project.order(id: :desc).limit(3)
      @country_average = LifestyleFootprintAverage.find_by_country(@footprint.country)

      respond_to do |format|
        format.html { render }
        format.json { render_price_json }
      end
    end

    # POST /resource
    #
    # This gets posted to from Javascript and can be retried after errors at
    # multiple points, hence lots of guards for different cases here.
    #
    # Rubocop warnings disabled because the "but no simpler" part of that
    # Einstein quote "As simple as possible, but no simpler".
    def create # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength
      render_user_invalid_json && return unless @user.save

      sign_in(resource_name, @user, force: true) # Force because we have updated the password
      
      puts "....................."
      puts params
      puts @plan_price
      puts "\n\n\n.....------................"

      puts "\n1\n"
      
      unless params[:no_subscription]
        puts "jkjkdjdjfdsjkhfshkjfshjka.------------"
        stripe_plan = Stripe::Plan.retrieve_or_create_climate_offset_plan(@plan_price)
        @manager.sign_up(@user.email, stripe_plan, params[:payment_method_id])
        
        if @manager.customer.present? && @user.stripe_customer_id != @manager.customer.id
          @user.update!(stripe_customer_id: @manager.customer.id)
        end
        puts "\n2\n"

        if @manager.errors.any?
          puts "\n2.1\n"
          render_signup_failed_json
        elsif @manager.payment_verification_required?
          puts "\n2.2\n"
          render_verification_required_json
        else
          puts "\n2.3\n"
          WelcomeMailer.with(email: @user.email).welcome_email.deliver_now
          render_success_json
        end
      else 
        puts "\n3\n"
        WelcomeMailer.with(email: @user.email).welcome_email.deliver_now
        render_success_json
      end
      
      
    rescue StandardError => e
      puts "\n4\n"
      # Respond explicitly so cookies gets set in responses where a user record
      # has been created that we want to reuse.
      logger.error(e)
      Raven.capture_exception(e)
      head :internal_server_error
    end

    # PUT /resource
    def update
      params[:user][:country] = nil if params[:user][:country] == ''

      super
    end

    protected

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      dashboard_path(registered: 1)
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def sign_up_params
      super.merge(
        lifestyle_footprint_ids: [@footprint&.id]
      )
    end

    def canonical_query_params
      super + [:choices]
    end

    private

    def set_footprint_and_price
      @footprint = LifestyleFootprint.find_by_key!(params[:lifestyle_footprint])

      unless @footprint.present? &&
             (@footprint.user_id.nil? || current_user.present? && @footprint.user_id == current_user.id)
        redirect_to root_url
        return
      end

      @footprint_tonnes = @footprint&.total
      @subscription_tonnes = @footprint_tonnes * (params[:people].presence&.to_i || 1)
      puts "set_footprint_and_price .. soon"
      @plan_price = SubscriptionManager.price_for_footprint(@subscription_tonnes, current_region.currency)
      puts "set_footprint_and_price .. done"
    end

    def set_user
      @user =
        if current_user.present?
          current_user.tap { |u| u.attributes = sign_up_params }
        else
          User.new(sign_up_params)
        end
    end

    def set_subscription_manager
      @manager = SubscriptionManager.new(@user.stripe_customer)
    end

    def render_price_json
      render json: {
        subscription: @subscription_tonnes.to_s(precision: :auto),
        price: @plan_price.to_s(precision: :auto)
      }
    end

    def render_user_invalid_json
      render status: :bad_request, json: error_json(@user.errors.full_messages.join(', '))
    end

    def render_signup_failed_json
      render status: :bad_request, json: error_json(@manager.errors.values.join(', '))
    end

    def render_verification_required_json
      render json: {
        next_step: :verification_required,
        payment_intent_client_secret: @manager.latest_payment_intent.client_secret,
        success_url: after_sign_up_path_for(@user)
      }
    end

    def render_success_json
      render json: {
        next_step: :redirect,
        success_url: after_sign_up_path_for(@user)
      }
    end

    def error_json(message)
      { error: { message: message } }
    end
  end
end
