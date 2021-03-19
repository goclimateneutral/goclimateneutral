# frozen_string_literal: true

module Admin
  class BusinessCalculatorsController < AdminController
    before_action :set_calculator, only: [:show, :edit, :update, :destroy]
    before_action :set_units, only: [:new, :edit, :update]

    def index
      @calculators = BusinessCalculators::Calculator.all.order(name: :asc)
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

    def destroy
      @calculator.destroy

      redirect_to admin_business_calculators_url, notice: 'Calculator was successfully destroyed.'
    end

    private

    def set_calculator
      @calculator = BusinessCalculators::Calculator.find(params[:id])
    end

    def set_units
      @units = BusinessCalculators::Unit.all.order(name: :asc)
    end

    def calculator_params
      params.require(:business_calculator).permit(
        :name,
        {
          categories_attributes: [
            :id,
            :name,
            :_destroy,
            { fields_attributes: [:id, :label, :_destroy, units: []] }
          ]
        }
      )
    end
  end
end
