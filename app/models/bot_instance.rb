class BotInstance < ApplicationRecord
  resourcify

  before_create :generate_key
  after_create :populate_priority

  belongs_to :bot
  belongs_to :user
  has_many :statistic

  def human_location
    "#{user.username}/#{location}"
  end

  def status
    return nil if last_ping.nil?

    if last_ping > 1.minute.ago
      :okay
    elsif last_ping < 1.minute.ago && last_ping > 3.minutes.ago
      :warn
    else
      :dead
    end
  end

  def status_class
    return 'bot-status-okay' if status == :okay
    return 'bot-status-warn' if status == :warn
    return 'bot-status-dead' if status == :dead

    'bot-status-nil'
  end

  def panel_class
    return 'panel-success' if status == :okay
    return 'panel-warning' if status == :warn
    return 'panel-danger' if status == :dead

    'panel-default'
  end

  def generate_key
    self.key = SecureRandom.hex 32
  end

  def populate_priority
    update(priority: id)
  end
end
