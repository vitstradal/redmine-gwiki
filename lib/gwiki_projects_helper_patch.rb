require_dependency 'projects_helper'

module GwikiProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :project_settings_tabs, :gwiki_tab
    end
  end

  module InstanceMethods
    # Adds a gwiki tab to the project settings page
    def project_settings_tabs_with_gwiki_tab
      tabs = project_settings_tabs_without_gwiki_tab
      tabs << { :name => 'gwiki', :action => :manage_gwiki_wiki, :partial => 'gwiki_wikis/edit', :label => 'Gwiki' }
      tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    end
  end
end
