class Nicepicture < ActiveRecord::Base
  attr_accessible :topic_id, :url
  belongs_to :topic

  def thumbnail
  	image = self.url
  	image.scan(/(.*)\./)[0][0]+ 'thumbnail' + image.gsub(/.*\./,".")
  end
end
