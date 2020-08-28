module BotInstancesHelper
  def version_link(bot, instance)
    return if bot.repository.nil? || bot.repository.empty?

    return 'unspecified' if instance.version == 'unspecified'

    if SemVer.parse(instance.version).valid?
      ActionController::Base.helpers.link_to instance.version, "#{bot.repository}/releases/tag/#{instance.version}"
    else
      ActionController::Base.helpers.link_to instance.version, "#{bot.repository}/commit/#{instance.version}"
    end
  end
end
