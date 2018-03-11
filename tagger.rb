require 'pdf-reader'

@image_files = []
@text_files = []

def tag_pdf(path)
  return if already_tagged? path
  puts "Tagging file #{path.sub(@base_path,'')}"
  reader = PDF::Reader.new(path)
  has_text = false
  
  reader.pages.each do |page|
    if page.text.length > 0
      has_text = true
      break
    end
  end

  if has_text
    split_name = File.split(path)
    new_name = File.join(split_name[0],"[text]#{split_name[1]}")
    File.rename(path, new_name)
    @text_files << new_name.sub(@base_path,'')
  else
    split_name = File.split(path)
    new_name = File.join(split_name[0],"[image]#{split_name[1]}")
    File.rename(path, new_name)
    @image_files << new_name.sub(@base_path,'')
  end
end

def already_tagged?(path)
  if File.basename(path).include? '[image]'
    puts "Already tagged #{path}"
    @image_files << path
    return true
  end

  if File.basename(path).include? '[text]'
    puts "Already tagged #{path}"
      @text_files << path
    return true
  end

  false
end

# Depth-first recursion
def traverse(path)
  Dir.each_child(path) do |child|
    child_path = File.join path, child
    if File.directory? child_path
      traverse child_path
    else
      tag_pdf child_path if File.extname(child_path) == '.pdf'
    end
  end
end

@base_path = ARGV[0]

raise StandardError, 'Must provide base path' if @base_path.to_s.empty?
raise StandardError, 'Base path not found' unless File.exists? @base_path
raise StandardError, 'Base directory must be directory' unless File.directory? @base_path

traverse @base_path

file = File.open(File.join(@base_path, 'image_files.txt'), 'w')
file.puts @image_files
file.close

file = File.open(File.join(@base_path, 'text_files.txt'), 'w')
file.puts @text_files
file.close