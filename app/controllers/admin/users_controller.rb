# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.where(admin: true)
    end

    def show
    end

    def edit
    end

    def update
      if @user.update(user_params)
        redirect_to [:admin, @user], notice: 'User was successfully updated!'
      else
        render :edit, notice: 'Something went wrong!'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:admin)
    end
  end
end
