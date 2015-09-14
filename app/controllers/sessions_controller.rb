class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      session[:user] = @user.attributes
      flash[:success] = 'Session set!'
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @user = User.new(session[:user])
  end

  def update
    @user = User.new(user_params)
    if @user.valid?
      session[:user] = @user.attributes
      flash[:succes] = "Session updated!"
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    session[:user] = nil
  end

  protected

  def user_params
    params.require(:user).permit(:client_id, :secret)
  end
end