module BotInstancesHelper
  def version_link(bot, instance)
    return if bot.repository.nil? || bot.repository.empty?

    if instance.version == "unspecified"
      return "unspecified"
    end

    if SemVer.parse(instance.version).valid?
      return ActionController::Base.helpers.link_to instance.version, "#{bot.repository}/releases/tag/#{instance.version}"
    else
      return ActionController::Base.helpers.link_to instance.version, "#{bot.repository}/commit/#{instance.version}"
    end
  end
end
