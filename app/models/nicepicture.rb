class Nicepicture < ActiveRecord::Base
  attr_accessible :topic_id, :url
  belongs_to :topic
end
