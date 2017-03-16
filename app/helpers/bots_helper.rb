module BotsHelper
  def repo_link(bot)
    if bot.repository.nil?
      "unspecified"
    else
      ActionController::Base.helpers.link_to URI.parse(bot.repository).host, bot.repository
    end
  end
end
