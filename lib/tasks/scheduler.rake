task :scanvideos => :environment do
    root = ''
    files = get_all_file_path(root).map {|file| file.sub! "#{root}/", ''} 
    files.each do |file_path|
        video = Video.find_by file_path: file_path 
        if video.nil?
            Video.create(title: file_path.split("/")[-1].split(".")[0], file_path: file_path)
        end
    end
    
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