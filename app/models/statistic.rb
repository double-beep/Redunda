class Statistic < ApplicationRecord
  belongs_to :bot_instances, optional: true
end
