require_dependency 'projects_helper'

module WigiProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :project_settings_tabs, :wigi_tab
    end
  end

  module InstanceMethods
    # Adds a wigi tab to the project settings page
    def project_settings_tabs_with_wigi_tab
      tabs = project_settings_tabs_without_wigi_tab
      tabs << { :name => 'wigi', :action => :manage_wigi_wiki, :partial => 'wigi_wikis/edit', :label => 'Wigi' }
      tabs.select {|tab| User.current.allowed_to?(tab[:action], @project)}
    end
  end
end
