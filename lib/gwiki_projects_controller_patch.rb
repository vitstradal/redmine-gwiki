require_dependency 'projects_controller'

module GwikiProjectsControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :settings, :gwiki_settings
    end
  end
 
  module InstanceMethods
    def settings_with_gwiki_settings
      settings_without_gwiki_settings
      @gwiki_wiki = @project.gwiki_wiki
    end
  end
end

