class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  def get_username(readonly_api_token, network_user_id=nil)
    begin
      config = AppConfig["stack_exchange"]

      resp = if network_user_id.present?
        resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/users/#{network_user_id}/associated?pagesize=1&filter=!-rYuN4gZ")).body)
        first_site = URI.parse(resp["items"][0]["site_url"]).host
        user_id = resp["items"][0]["user_id"]

        JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/users/#{user_id}?site=#{first_site}&filter=!-.wwQ56Mfo3J")).body)
      else
        auth_string = "key=#{config["key"]}&access_token=#{readonly_api_token || api_token}"
        resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=1&filter=!ms3d6aRI6N&#{auth_string}")).body)

        first_site = URI.parse(resp["items"][0]["site_url"]).host

        JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me?site=#{first_site}&filter=!-.wwQ56Mfo3J&#{auth_string}")).body)
      end

      return resp["items"][0]["display_name"]
    rescue
      return
    end
  end

  # Helper method to return an HTML link for a user.
  def link
    return ActionController::Base.helpers.link_to username, "//stackexchange.com/users/#{stack_exchange_account_id}"
  end
end
