require 'redmine'

Rails.configuration.to_prepare do
  require 'grit'
  require 'trac-wiki'

#  # project model should be patched before projects controller
  Project.send(:include, WigiProjectModelPatch) unless Project.included_modules.include?(WigiProjectModelPatch)
  ProjectsController.send(:include, WigiProjectsControllerPatch) unless ProjectsController.included_modules.include?(WigiProjectsControllerPatch)
  ProjectsHelper.send(:include, WigiProjectsHelperPatch) unless ProjectsHelper.included_modules.include?(WigiProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_wigi do
  name 'Redmine Git (trac) wiki plugin'
  author 'vitas  <vitas@matfyz.cz>'
  description 'Wigi: trac-wiki with git backed plugin for redmine'

  # use git to get version name
  repo = Grit::Repo.new("#{Rails.root}/plugins/redmine_wigi/.git")
  version repo.recent_tag_name('HEAD', :tags=>true)

  url 'https://github.com/vitstradal/redmine-wigi/'
  author_url 'http://vitas.matfyz.cz'

  requires_redmine :version_or_higher => '2.0.2'

  settings :default => {
                       :wigi_base_path => Pathname.new(Rails.root + "wigi")
                       },
           :partial => 'shared/settings'

  project_module :wigi do
    permission :view_wigi_pages,   :wigi => [:index, :show]
    permission :add_wigi_pages,    :wigi => [:new, :create]
    permission :edit_wigi_pages,   :wigi => [:edit, :update]
    permission :delete_wigi_pages, :wigi => [:destroy]
    permission :manage_wigi_wiki,  :wigi_wikis => [:index,:show, :create, :update]
  end

  menu :project_menu, :wigi, { :controller => :wigi, :action => :index }, :caption => 'wigi', :before => :wiki, :param => :project_id
end
