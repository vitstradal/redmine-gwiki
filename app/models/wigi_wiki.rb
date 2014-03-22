class WigiWiki < ActiveRecord::Base
  unloadable
  belongs_to :project
end
