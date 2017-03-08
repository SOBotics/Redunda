require 'net/http'
include AuthenticationHelper

class AuthenticationController < ApplicationController
  before_action :verify_development, :only => [:dev_login, :submit_dev_login]

  def login_redirect_target
    if user_signed_in?
      flash[:error] = "You're already signed in."
      redirect_to root_path and return
    end

    token = access_token_from_code(params[:code], AppConfig["stack_exchange"]["login_redirect_uri"])
    access_token_info = info_for_access_token(token)

    user = User.find_by_stack_exchange_account_id(access_token_info["account_id"])

    if user.present?
      flash[:success] = "Successfully logged in as #{user.username}"
      sign_in_and_redirect user
    else
      user = User.new(stack_exchange_account_id: access_token_info["account_id"])

      user.username = user.get_username(token)
      user.password = user.password_confirmation = SecureRandom.hex

      user.save!

      flash[:success] = "New account created for #{user.username}. Have fun!"
      sign_in_and_redirect user
    end 
  end

  def dev_login

  end

  def submit_dev_login
    user = User.find_by_stack_exchange_account_id(params[:account_id])

    if user.present?
      flash[:success] = "Successfully logged in as #{user.username}"
      sign_in_and_redirect user
    else
      user = User.new(stack_exchange_account_id: params["account_id"])

      user.username = user.get_username(nil, params[:account_id])
      user.password = user.password_confirmation = SecureRandom.hex

      user.save!

      flash[:success] = "New account created for #{user.username}. Have fun!"
      sign_in_and_redirect user
    end
  end

  private
    def verify_development
      unless Rails.env.development?
        render :plain => "", :status => :forbidden and return
      end
    end
end
