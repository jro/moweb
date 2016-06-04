
module MoWEB
  def self.display_help_and_exit
    puts "moweb <path>"
    puts
    puts "Path can be file or directory to recurse into"
    exit
  end
end
module MoWEB
  def self.grab_fenced_code(str="")
    str.scan(/^>>\s([^\n]+)\n\n^```(\w+)?$(.*?)\n^```$\n/m)
  end
end
module MoWEB
  def self.output_code(base_path,snippet)
    filepath = [ base_path, snippet[1] ].join("/")
    language = snippet[2]
    code     = snippet[3]

    file = fetch_file(filepath)
    file << code
  end
end
require "option_parser"

module MoWEB
  @@files = {} of String => File

  def self.fetch_file(filepath)
    @@files.fetch(filepath) do
      @@files[filepath] = File.open(filepath,"w+")
    end
  end

  def self.close_all_files
    @@files.each_value {|f| f.close }
  end

  def self.process_file(file)
    src  = File.read(file)
    path = File.dirname(File.expand_path(file))

    grab_fenced_code(src).each do |snippet|
      output_code(path,snippet)
    end
  end

  def self.run
    path = ARGV.size > 0 ? ARGV.first : nil
    display_help_and_exit unless ( path && File.exists?(path) )

    if File.directory?(path)
      Dir.glob(path + "/**/*.md").each do |f|
        process_file(f)
      end
    else
      process_file(path)
    end
    close_all_files
  end
end

MoWEB.run