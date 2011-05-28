require 'net/http'
require 'net/https'
require 'json'
require 'pp'


module GemIgnore

  #--
  # FIXME: Not a good name, but for now its okay
  # FIXME: Add documentation
  # FIXME: Cleanup code
  #++
  class Main

    def dispatch
      list if ARGV.length === 0
      search if ARGV.length === 1
      add if ARGV.length === 2 and ARGV[0] === "add"
    end

    # Displays a list of available .gitignore snippets
    def list
      puts "-> Available .gitignore snippets:"
      fetch().each do |f|
        puts "---> " + f
      end
    end

    # Searches for a given snippet name
    def search
      puts "-> Snippets found for '#{ARGV[0]}':"
      fetch(regexpForInput(ARGV[0])).each do |f|
        puts "---> " + f
      end
    end

    # Adds the snippet to the .gitignore file in the current working
    # directory in case it exists and the given snippet identifier matched
    # exactly one snippet.
    def add
      snippets = fetch(regexpForInput(ARGV[1]))
      if snippets.length < 1
        puts "-> No snippets found"
      elsif snippets.length > 1
        puts "-> Multiple possible snippets found:"
        snippets.each do |f|
          puts "---> " + f
        end
      else
        performAdd(snippets.first)
      end
    end

    # Adds the given snippet in case the .gitignore file exists.
    def performAdd(snippet)
      if not File.exists?(".gitignore")
        puts "No .gitignore file found in working directory"
      else

        puts "Adding Snippet '#{snippet}'"

        f = File.new(".gitignore", "a")
        snippetData = fetchFile(snippet)
        f.write("\n\n# Added by gemignore. Snippet '#{snippet}'\n" + snippetData)
        f.close
      end
    end

    # Creates a case-insensitive Regexp for the given string. Wildcards are
    # added before and after the input, so the regex will match anything containing
    # the input, or the input itself.
    def regexpForInput(input)
      input = Regexp.escape(input)
      Regexp.new("(.*#{input}.*)", Regexp::IGNORECASE)
    end

    # Fetches the list of available snippets via the GitHub API
    #--
    # FIXME: Do some (url) refactoring
    #++
    def fetch(search = nil)
      search = /(.*)/ if search === nil

      data = Net::HTTP.get( URI.parse('http://github.com/api/v2/json/blob/all/github/gitignore/master') )
      response = JSON.parse(data)
      files = response["blobs"].map { |k,v| t = k.split('.'); (t[0] =~ search; $1) if t.last === 'gitignore'  }
      files.compact
    end

    # Fetches a snippet file from GitHub
    #--
    # FIXME: Do some (url) refactoring
    #++
    def fetchFile(snippet)
      url = URI.parse("https://github.com/github/gitignore/raw/master/#{snippet}.gitignore")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS

      data = ""
      http.start {
        http.request_get(url.path) {|res|
          data = res.body
        }
      }

      data
    end
  end


end