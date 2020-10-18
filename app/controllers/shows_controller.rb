class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @seasons = Season.where("show_id = ?", @show.id)
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows
  # POST /shows.json
  def create
    root = "#{Rails.root.to_s}/public/videos"
    shows_path = get_all_shows(root)
    seasons = []
    shows_path.each do |show_path|
        show = save_db(Show,  {title: show_path.split("/")[-1], dir_path: show_path}, true)
        get_all_seasons(show_path).each do |season_path|
            season = save_db(Season, {title: season_path.split("/")[-1], dir_path: season_path, show_id: show.id}, true)
            seasons << season
        end
    end
    seasons.each do |season|
        path = season.dir_path
        files = get_all_file_path(path).map {|file| file.sub! "#{root}/", ''} 
        files.each do |file_path|
            save_db(Video, {title: file_path.split("/")[-1], file_path: file_path, season_id:season.id})
        end
    end
  end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url, notice: 'Show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def show_params
      params.require(:show).permit(:title, :dir_path)
    end

    def save_db(model, object, is_dir=false)
      p "#{model}"
      p object
      if is_dir 
          instance = model.find_by dir_path: object[:dir_path] 
      else
          instance = model.find_by file_path: object[:file_path] 
      end
      if instance.nil?
          instance = model.create!(object)
      end
      p instance
      instance
    end
    
    def get_all_seasons(root)
        ans = []
        files = Dir.entries(root)
        files.delete(".")
        files.delete("..")
        files.each do |file|
            file_path = "#{root}/#{file}"
            if File.directory? file_path
                ans << file_path
            end
        end
        ans
    end
    
    def get_all_shows(root)
        ans = []
        files = Dir.entries(root)
        files.delete(".")
        files.delete("..")
        files.each do |file|
            file_path = "#{root}/#{file}"
            if File.directory? file_path
                ans << file_path
            end
        end
        ans
    end
    
    def get_all_file_path(root)
        ans = []
        accepted_formats = ['.mp4']
        files = Dir.entries(root)
        files.delete(".")
        files.delete("..")
        files.each do |file|
            file_path = "#{root}/#{file}"
            if File.directory? file_path
                ans = ans + get_all_file_path(file_path)
            else
                if accepted_formats.include? File.extname(file_path)
                    ans << file_path
                end
            end
        end
        ans
    end
end
