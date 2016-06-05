# Hi, I'm Mo` WEB

I'm a code preprocessor to enable
[Literate Programming](https://en.wikipedia.org/wiki/Literate_programming)
by grabbing bits of sourcecode from
[Markdown](https://guides.github.com/features/mastering-markdown/)
files. You're actually staring at my sourcecode right now. Creepy?

>> moweb.cr

```crystal
require "option_parser"

module MoWEB
```

There I go, defining myself. But, literate programming isn't new, I'm
standing on the shoulders of
giants. [WEB](https://en.wikipedia.org/wiki/WEB) and
[noweb](https://en.wikipedia.org/wiki/Noweb) and more in our
[resources](##Resources)

## Using me

Everyone gets used, right? I don't need a lot of info, just the path
to a file or directory you want to process: `moweb ./some/path/to/file_or_directory`

>> moweb.cr

```crystal
@@files = {} of String => File

def self.display_help_and_exit
  puts "moweb <path>"
  puts
  puts "Path can be file or directory to recurse into"
  exit
end

def self.fetch_file(filepath)
  @@files.fetch(filepath) do
    @@files[filepath] = File.open(filepath,"w+")
  end
end

def self.process_file(file)
  src  = File.read(file)
  path = File.dirname(File.expand_path(file))

  grab_fenced_code(src).each do |snippet|
    output_code(path,snippet)
  end
end

def self.close_all_files
  @@files.each_value {|f| f.close }
end
```

Then, you'll need to run `make` or whatever to actually build or run
your source code. We defined our `Makefile` over [here](BUILDING.md)
in markdown.

## Coding

You're probably wondering what magic you need for writing code? We
tend to follow github-flavored markdown for now, and look for a
double-birded (`>>`) filename, then a newline, then a fenced code
block. An example is probably more clear:

    # some markdown
    
    >> filename.something
    
    ```optional_language_name
    some
    really
    awesome
    code
    ```
    
     * more markdown

This all gets eaten up by a fancy regexp

>> moweb.cr

```crystal
def self.grab_fenced_code(str="")
  str.scan(/^>>\s([^\n]+)\n\n^```(\w+)?$(.*?)\n^```$\n/m)
end
```

And written out based on the prefixed filename

>> moweb.cr

```crystal
def self.output_code(base_path,snippet)
  filepath = [ base_path, snippet[1] ].join("/")
  language = snippet[2]
  code     = snippet[3]

  file = fetch_file(filepath)
  file << code
end
```

## Installation

I know, I know. You're itching to start writing your code in essay
form too. But, I don't have an install file yet. For now you'll need
to check out [building](BUILDING.md) docs.

## Resources

* [Literate Programming](http://literateprogramming.com/knuthweb.pdf)
  [pdf] - the original essay by Donald Knuth from 1983
* [Literate Emacs Starter Kit](https://github.com/eschulte/emacs24-starter-kit)
* [Literate Programming in Haskell](https://wiki.haskell.org/Literate_programming)

## Developing

You've already seen most of my code. The only bit left is:

>> moweb.cr

```crystal
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
```

That really just glues it all together.

>> moweb.cr

```crystal
end

MoWEB.run
```

fin.

## Todo

* Useful specs
* Static versions for download
  * CI -> github artifacts

## Contributing

1. Fork it ( https://github.com/jro/moweb/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Jason Rohwedder](https://github.com/jro)
