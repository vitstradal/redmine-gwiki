require_dependency 'user'

class GwikiController < ApplicationController
  unloadable

  before_filter :find_project, :find_wiki, :authorize

  def index
    redirect_to :action => :show, :id => "Home"
  end

  def show
    path = params[:id]
    @text, @version = @giwi.get_page(path)
    parser = TracWiki.parser(_trac_wiki_options(base))
    @html = parser.to_html(@text)
    @headings = parser.headings
    if parser.headings.size > 3
      @toc = parser.make_toc_html
    end
  end

  def edit
  end

  def update
  end

  private

  def show_page(name)
  end

  def project_repository_path
    return @project.gollum_wiki.git_path
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])
  end

  def find_wiki
    git_path = project_repository_path
    options = {}
    @giki = Giki.new(@project.id, options)
    #@giwi = Giwi.get_giwi(@wiki)


  end
end
