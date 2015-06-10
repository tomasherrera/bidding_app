class UsersController < ApplicationController
  def create
    @user = User.new(budget: params[:budget])
    if @user.save
      respond_to do |format|
        format.json
      end
    else
      render :json => {:errors => @user.errors.full_messages}
    end
  end
end
