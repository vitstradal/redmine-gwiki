require_dependency 'project'

module WigiProjectModelPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
 
  module InstanceMethods
    def wigi_wiki
      raise "Need project id." unless self.id
      return WigiWiki.first(:conditions => ["project_id = ?", self.id]) ||
             WigiWiki.new( :project_id => self.id,
                            :git_path   => Setting.plugin_redmine_wigi[:giwi_base_path].to_s + "/#{self.identifier}.wiki.git".to_s)
    end
  end
end

