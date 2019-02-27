class PasswordsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :get_user, only: [:edit, :update]
  before_action :authorised_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
	  user = User.find_by(email: params[:email])
	  if user.present?
	    user.create_reset_digest
	    user.send_password_reset_email
      redirect_to login_path, notice: 'Reset password instruction sent to email: ' + user.email
	  else
      flash.now[:alert] = 'Email not found.'
      render 'new'
    end
  end

  def edit
  end

  def update
  	if params[:password].blank?
      flash.now[:notice] = 'Password is blank.'
	    render :new
	  elsif @user.update_attributes(password: params[:password], password_confirmation: params[:password_confirmation])
	    @user.update_attribute(:reset_digest, nil)
	    redirect_to login_path, notice: 'Your password has been changed successfully.'
	  end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def authorised_user
    unless (@user && @user.authenticated?(:reset, params[:id]))
      redirect_to new_password_path, notice: 'You are not authorize to perform this action.' and return
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      redirect_to new_password_path, notice: 'Reset password token has been expired or invalid' and return
    end
  end
end
