class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  def get_username(readonly_api_token)
    begin
      config = AppConfig["stack_exchange"]
      auth_string = "key=#{config["key"]}&access_token=#{readonly_api_token || api_token}"

      resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=1&filter=!ms3d6aRI6N&#{auth_string}")).body)

      first_site = resp["items"][0]["site_url"]

      resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me?site=stackoverflow&filter=!-.wwQ56Mfo3J&#{auth_string}")).body)

      return resp["items"][0]["display_name"]
    rescue
      return
    end
  end
end
