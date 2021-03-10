# frozen_string_literal: true

module Admin
  class OrganizationsController < AdminController
    before_action :set_organization, only: [:show, :edit, :update, :destroy]

    def index
      @organizations = Organization.all.order(name: :asc)
    end

    def show
    end

    def new
      @organization = Organization.new
    end

    def edit
    end

    def create
      @organization = Organization.new(organization_params)

      if @organization.save
        redirect_to [:admin, @organization], notice: 'Organization was successfully created.'
      else
        render :new
      end
    end

    def update
      if @organization.update(organization_params)
        redirect_to [:admin, @organization], notice: 'Organization was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @organization.destroy

      redirect_to admin_organizations_url, notice: 'Organization was successfully destroyed.'
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name)
    end
  end
end
