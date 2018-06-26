class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  def after_database_authentication
    Thread.new do
      begin
        update(username: get_username(nil, stack_exchange_account_id))
      rescue
      end
    end
  end

  def get_username(readonly_api_token, network_user_id=nil)
    begin
      config = AppConfig["stack_exchange"]

      resp = if network_user_id.present?
        resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/users/#{network_user_id}/associated?pagesize=1&filter=!-rYuN4gZ&key=#{config["key"]}")).body)
        first_site = URI.parse(resp["items"][0]["site_url"]).host
        user_id = resp["items"][0]["user_id"]

        JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/users/#{user_id}?site=#{first_site}&filter=!-.wwQ56Mfo3J&key=#{config["key"]}")).body)
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

  Role.global_role_names.each do |role|
    define_method "is_#{role}?" do
      self.has_role?(role)
    end
  end

  Role.scoped_roles.each do |role, resource|
    define_method "is_#{role}?" do |res_arg|
      res_arg.is_a?(resource) && self.has_role?(role, res_arg)
    end
  end
end
