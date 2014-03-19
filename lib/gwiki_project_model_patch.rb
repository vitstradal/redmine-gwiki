require_dependency 'project'

module GwikiProjectModelPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end
 
  module InstanceMethods
    def gwiki_wiki
      raise "Need project id." unless self.id
      return GwikiWiki.first(:conditions => ["project_id = ?", self.id]) ||
             GwikiWiki.new( :project_id => self.id,
                            :git_path   => Setting.plugin_redmine_gwiki[:gwiki_base_path].to_s + "/#{self.identifier}.wiki.git".to_s)
    end
  end
end

