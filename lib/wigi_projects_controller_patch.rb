require_dependency 'projects_controller'

module WigiProjectsControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.class_eval do
      alias_method_chain :settings, :wigi_settings
    end
  end
 
  module InstanceMethods
    def settings_with_wigi_settings
      settings_without_wigi_settings
      @wigi_wiki = @project.wigi_wiki
    end
  end
end

