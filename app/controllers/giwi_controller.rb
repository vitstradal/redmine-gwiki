require_dependency 'user'

class WigiController < ApplicationController
  unloadable

  before_filter :find_project, :find_wiki, :authorize

  @@parser = TracWiki.parser(edit_heading: true)

  def index
    redirect_to project_wigi_show_path(@project.id, @wigi.default_page)
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
      return redirect_to id: @giwi.directory + id + '/' + @wigi.default_page if @giwi.dir?(@wigi.directory + id) && @wigi.default_page != ''
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
    if @edit == 'me'
       # edit whole page
       @page_text, @version = @giwi.get_page(@path + @giwi.ext)
       @edit = true
       return
    end

    die "wrong edit value" if @edit !~  /^\d+$/

    # want to edit only one chapter
    @part = @edit.to_i

    text, @version = @giwi.get_page(@path + @giwi.ext)

    if text
      parser = TracWiki.parser(math: true, merge: true,  no_escape: true, allow_html: true,)
      parser.to_html(text)
      heading = parser.headings[@part]
      if heading
        # edit only selected part (from @sline to @eline)
        @page_text = text.split("\n").values_at(heading[:sline]-1 .. heading[:eline]-1).join("\n")
        @sline = heading[:sline]
        @eline = heading[:eline]
      else
        # edit all document anyway
        @part = nil
      end
    end
  end

  def _get_page_path(id)
    @wigi.directory + id + @wigi.ext
  end

  def find_project
    unless params[:project_id].present?
      render :status => 404
      return
    end

    @project = Project.find(params[:project_id])
  end

  def find_wiki
    @wigi = @project.wigi_wiki
    @giwi = Giwi.new(@project.id.to_s, :path   => @wigi.git_path,
                                       :bare   => @wigi.is_bare,
                                       :branch => @wigi.branch,
                                       )
  end
end
