class Image < ActiveRecord::Base
  validates_uniqueness_of :image_id
end
