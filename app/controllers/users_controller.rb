class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])

    if user_signed_in?
      @name = current_user.name
      @prototypes = current_user.prototypes
    end
  end
end