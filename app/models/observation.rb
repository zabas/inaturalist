class Observation < ActiveRecord::Base
  has_many :observation_photos, :dependent => :destroy
  has_many :photos, :through => :observation_photos
end
