module AuthenticationHelper
  require 'open-uri'

  def auth_url(scope, redirect_uri)
    config = AppConfig["stack_exchange"]
    "https://stackexchange.com/oauth?client_id=#{config["client_id"]}&scope=#{scope}&redirect_uri=#{redirect_uri}"
  end

  def write_auth_url
    config = AppConfig["stack_exchange"]
    auth_url("write_access,no_expiry", config["redirect_uri"])
  end

  def identify_auth_url
    config = AppConfig["stack_exchange"]
    auth_url("", config["redirect_uri"])
  end

  def login_auth_url
    config = AppConfig["stack_exchange"]
    auth_url("", config["login_redirect_uri"])
  end

  def signup_auth_url
    login_auth_url
  end

  def access_token_from_code(code, redirect_uri=AppConfig["stack_exchange"]["redirect_uri"])
    config = AppConfig["stack_exchange"]

    request_params = { "client_id" => config["client_id"], "client_secret" => config["client_secret"], "code" => params[:code], "redirect_uri" => redirect_uri }
    response = Rack::Utils.parse_nested_query(Net::HTTP.post_form(URI.parse('https://stackexchange.com/oauth/access_token'), request_params).body)

    response["access_token"]
  end

  def info_for_access_token(access_token)
    config = AppConfig["stack_exchange"]
    JSON.parse(open("https://api.stackexchange.com/2.2/access-tokens/#{access_token}?key=#{config["key"]}").read)["items"][0]
  end

  def username_for_access_token(access_token)
    begin
      config = AppConfig["stack_exchange"]
      auth_string = "key=#{config["key"]}&access_token=#{readonly_api_token || api_token}"

      resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?pagesize=1&filter=!ms3d6aRI6N&#{auth_string}")).body)

      first_site = resp["items"][0]["site_url"]

      resp = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me?site=stackoverflow&filter=!-.wwQ56Mfo3J&#{auth_string}")).body)

      resp["items"][0]["display_name"]
    rescue
      nil
    end
  end
end
