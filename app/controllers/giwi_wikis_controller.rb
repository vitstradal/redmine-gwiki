class WigiWikisController < ApplicationController
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
    wigi_wiki = @project.wigi_wiki
    wigi_wiki.attributes = params[:wigi_wiki]
    if wigi_wiki.save
      flash[:notice] = t(:wigi_wiki_updated)
    else
      flash[:error] = t(:wigi_wiki_update_error)
    end
    redirect_to(:controller => 'projects', :action => 'settings', :id => @project, :tab => 'wigi')
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
