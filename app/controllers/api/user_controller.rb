class Api::UserController < ApplicationController
  before_action :set_user, :only => [:show, :update, :destroy]

  def index
    render :json => User.all
  end

  def create
    render :json => User.create(user_params)
  end

  def show
    render :json => @user
  end

  def update
    #As of now sending empty json if user not present
    if @user.present?
      render :json => @user
    else
      render :json => []
    end
  end

  def destroy
    @user.destroy
    render :json => []
  end

  def typeahead
    str = "%#{params[:input]}%"
    users = User.where("firstName LIKE ? or lastName LIKE ? or email LIKE ?", str, str, str)
    render :json => users.map{ |user|
      user.firstName + ' ' + user.lastName
    }.join(' and ')
  end

  private

  def set_user
    @user = User.find_by_id params[:id]
  end

  def user_params
    params.require(:user).permit(:firstName, :lastName, :email)
  end
end
