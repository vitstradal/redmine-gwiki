require_dependency 'user'

class GwikiController < ApplicationController
  unloadable

  before_filter :find_project, :find_wiki, :authorize

  @@parser = TracWiki.parser(edit_heading: true)

  def index
    redirect_to :action => :show, :id => @gwiki.default_page
  end

  def show
    @editable = true
    id =  params[:id]
    @edit =  params[:edit]

    return _handle_edit if @edit

    if id =~ /\.png$/
      return _handle_file(id)
    end


    @page_path = _get_page_path(id)
    @page_text, @version = @giwi.get_page(@page_path)

    if @page_text.nil?
      return redirect_to id: @giwi.directory + id + '/' + @gwiki.default_page if @giwi.dir?(@gwiki.directory + id) && @gwiki.default_page != ''
      return redirect_to  edit: :me, id: id
    end

    @page_html = @@parser.to_html(@page_text)
    @headings = @@parser.headings
    if @@parser.headings.size > 3
      @toc = @@parser.make_toc_html
    end
  end


  def update
    @page_path = params[:id]
    @page_text = params[:page_text]
    @version = params[:version]
    @user = User.current

    # status = @giwi.set_page(@path + @giwi.ext, text, version, email, sline , eline)
    status = @giwi.set_page(@page_path, @page_text, @version, @user.mail )
    redirect_to action: :show , id: @page_path
  end

  private

  def _handle_edit
    id = params[:id]
    @page_path = _get_page_path(id)
    @page_text, @version = @giwi.get_page(@page_path)
    if @page_text.nil?
      @page_text, @version = ["== #{id} ==\n\n",'']
    end
  end

  def _get_page_path(id)
    @gwiki.directory + id + @gwiki.ext
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])
  end

  def find_wiki
    @gwiki = @project.gwiki_wiki
    @giwi = Giwi.new(@project.id.to_s, :path   => @gwiki.git_path,
                                       :bare   => @gwiki.is_bare,
                                       :branch => @gwiki.branch,
                                       )
  end
end
