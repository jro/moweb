# Mo` WEB

`moweb` enables
[Literate Programming](https://en.wikipedia.org/wiki/Literate_programming)
by acting as a preprocessor to
[Markdown](https://guides.github.com/features/mastering-markdown/)
files containing fenced code blocks. It aspires to follow in the
footsteps of [WEB](https://en.wikipedia.org/wiki/WEB) and [noweb](https://en.wikipedia.org/wiki/Noweb).

## Installation

TODO: Write installation instructions here

## Usage

### Commandline

Basic usage to render source files: `moweb ./some/path/to/file_or_directory`

> moweb.cr
```crystal
module MoWEB
  def self.display_help_and_exit
    puts "moweb <path>"
    puts
    puts "Path can be file or directory to recurse into"
    exit
  end
end
```

After which you may need to run a compilation or interpreter step
depending on your language(s). Setting up a `Makefile` may make this
easier on some projects

### Writing the Markdown

Our current format is

> ..some markdown
> 
> > filename.something
> ```optional_language_name
> some
> really
> awesome
> code
> ```
> more markdown

which gets eaten up by a fancy regexp

> moweb.cr
```crystal
module MoWEB
  def self.grab_fenced_code(str="")
    str.scan(/^>\s([^\n]+)\n^```(\w+)?$(.*?)\n^```$\n/m)
  end
end
```

Which gets written out based on the prefixed filename
> moweb.cr
```crystal
module MoWEB
  def self.output_code(snippet)
    filename = snippet[1]
    language = snippet[2]
    code     = snippet[3]

    file = fetch_file(filename)
    file << code
  end
end
```

## Literate Programming Resources

* [Literate Programming](http://literateprogramming.com/knuthweb.pdf)
  [pdf] - the original essay by Donald Knuth from 1983
* [Literate Emacs Starter Kit](https://github.com/eschulte/emacs24-starter-kit)
* [Literate Programming in Haskell](https://wiki.haskell.org/Literate_programming)

## Development

TODO: Write development instructions here

## Todo

* Useful specs
* Static versions for download
  * CI -> github artifacts

## Contributing

1. Fork it ( https://github.com/jro]/moweb/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Jason Rohwedder](https://github.com/jro)


> moweb.cr
```crystal
require "option_parser"

module MoWEB
  @@files = {} of String => File

  def self.fetch_file(filepath)
    @@files.fetch(filepath) do
      @@files[filepath] = File.open(filepath,"w+")
    end
  end

  def self.run
    file = ARGV.size > 0 ? ARGV.first : nil
    display_help_and_exit unless ( file && File.exists?(file) )

    f = File.read(file)
    grab_fenced_code(f).each do |snippet|
      output_code(snippet)
    end

    @@files.each {|x,y| y.close }
  end
end

MoWEB.run
```

