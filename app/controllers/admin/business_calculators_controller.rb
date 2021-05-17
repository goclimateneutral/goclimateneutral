# frozen_string_literal: true

module Admin
  class BusinessCalculatorsController < AdminController
    before_action :set_calculator, only: [:show, :edit, :update, :destroy, :publish, :archive, :duplicate]
    before_action :set_units, only: [:new, :edit, :update]
    before_action :verify_editable, only: [:edit, :update]

    def index
      not_archived = BusinessCalculators::Calculator.where("status != 'archived'").order(name: :asc)
      archived = BusinessCalculators::Calculator.where(status: 'archived').order(name: :asc)
      @calculators = not_archived + archived
    end

    def show
    end

    def new
      @calculator = BusinessCalculators::Calculator.new
    end

    def edit
    end

    def create
      @calculator = BusinessCalculators::Calculator.new(calculator_params)

      if @calculator.save
        redirect_to [:admin, @calculator], notice: 'Calculator was successfully created.'
      else
        render :new
      end
    end

    def update
      if @calculator.update(calculator_params)
        redirect_to [:admin, @calculator], notice: 'Calculator was successfully updated.'
      else
        render :edit
      end
    end

    def publish
      @calculator.publish

      redirect_to admin_business_calculators_url, notice: 'Calculator was successfully published.'
    end

    def archive
      @calculator.archive

      redirect_to admin_business_calculators_url, notice: 'Calculator was successfully archived.'
    end

    def duplicate # rubocop:disable Metrics/MethodLength
      new_calculator = @calculator.dup
      new_calculator.name = "#{new_calculator.name} (copy)"
      new_calculator.status = 'draft'

      if new_calculator.save
        @calculator.categories.each do |category|
          new_category = category.dup
          new_category.calculator_id = new_calculator.id
          new_category.save

          category.fields.each do |field|
            new_field = field.dup
            new_field.category_id = new_category.id
            new_field.save
          end
        end
        redirect_to admin_business_calculators_url, notice: 'Calculator was successfully duplicated.'
      else
        redirect_to admin_business_calculators_url, notice: 'Something went wrong - calculator was not duplicated 😬'
      end
    end

    private

    def set_calculator
      @calculator = BusinessCalculators::Calculator.find(params[:id])
    end

    def set_units
      @units = BusinessCalculators::Unit.all.order(name: :asc)
    end

    def verify_editable
      redirect_to admin_business_calculators_url, notice: 'Publihsed/archived calculator can\'t be edited.' unless @calculator.draft? # rubocop:disable Metrics/LineLength
    end

    def calculator_params
      params.require(:business_calculator).permit(
        :name,
        {
          categories_attributes: [
            :id,
            :name,
            :description,
            :_destroy,
            { fields_attributes: [:id, :label, :field_type, :_destroy, units: []] }
          ]
        }
      )
    end
  end
end
