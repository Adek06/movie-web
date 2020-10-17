task :scanvideos => :environment do
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
