class GwikiWiki < ActiveRecord::Base
  unloadable
  belongs_to :project
end
