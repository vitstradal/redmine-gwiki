require 'redmine'

Rails.configuration.to_prepare do
  require 'grit'
  require 'trac-wiki'

#  # project model should be patched before projects controller
#  Project.send(:include, GollumProjectModelPatch) unless Project.included_modules.include?(GollumProjectModelPatch)
#  ProjectsController.send(:include, GollumProjectsControllerPatch) unless ProjectsController.included_modules.include?(GollumProjectsControllerPatch)
#  ProjectsHelper.send(:include, GollumProjectsHelperPatch) unless ProjectsHelper.included_modules.include?(GollumProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_gwiki do
  name 'Redmine Git (trac) wiki plugin'
  author 'vitas  <vitas@matfyz.cz>'
  description 'Gwiki: trac-wiki with git backed plugin for redmine'

  # use git to get version name
  repo = Grit::Repo.new("#{Rails.root}/plugins/redmine-trac-wiki/.git")
  version repo.recent_tag_name('HEAD', :tags=>true)

  url 'https://github.com/vitstradal/redmine-trac-wiki-git/'
  author_url 'http://vitas.matfyz.cz'

  requires_redmine :version_or_higher => '2.0.2'

  settings :default => {
                       :gwiki_base_path => Pathname.new(Rails.root + "gwiki")
                       },
           :partial => 'shared/settings'

  project_module :gwiki do
    permission :view_gwiki_pages,   :gwiki => [:index, :show]
    permission :add_gwiki_pages,    :gwiki => [:new, :create]
    permission :edit_gwiki_pages,   :gwiki => [:edit, :update]
    permission :delete_gwiki_pages, :gwiki => [:destroy]
    permission :manage_gwiki_git,   :gwiki_wikis => [:index,:show, :create, :update]
  end

  menu :project_menu, :gwiki, { :controller => :gwiki, :action => :index }, :caption => 'GWiki', :before => :wiki, :param => :project_id
end
