class GwikiWikisController < ApplicationController
  menu_item :settings
  unloadable

  before_filter :find_project, :authorize

  def index
    redirect_to :action => :show
  end

  def create
    update
  end

  def update
    gwiki_wiki = @project.gwiki_wiki
    gwiki_wiki.attributes = params[:gwiki_wiki]
    if gwiki_wiki.save
      flash[:notice] = t(:gwiki_wiki_updated)
    else
      flash[:error] = t(:gwiki_wiki_update_error)
    end
    redirect_to(:controller => 'projects', :action => 'settings', :id => @project, :tab => 'gwiki')
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
