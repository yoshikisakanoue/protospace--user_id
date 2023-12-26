class UsersController < ApplicationController
  def show
    @name = current_user.name
    @prototypes = current_user.prototypes
    @user = User.find(params[:id])
  end
end
