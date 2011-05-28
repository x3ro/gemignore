require 'rubygems'
require 'rainbow'
require 'net/http'
require 'net/https'
require 'json'

require 'gemignore/util'

module GemIgnore

  #--
  # FIXME: Not a good name, but for now its okay
  # FIXME: Add documentation
  # FIXME: Cleanup code
  #++
  class Main

    include Util

    def dispatch
      list if ARGV.length === 0
      search if ARGV.length === 1
      add if ARGV.length === 2 and ARGV[0] === "add"
    end

    # Displays a list of available .gitignore snippets
    def list
      msg "Available .gitignore snippets:", 1
      fetch().each do |f|
        notice f, 2
      end
    end

    # Searches for a given snippet name
    def search
      results = fetch(regexpForInput(ARGV[0]))
      if(results.length === 0)
        error "No snippets found for '#{ARGV[0]}'", 1
      else
        msg "Snippets found for '#{ARGV[0]}':", 1
        results.each do |f|
          notice f, 2
        end

      end
    end

    # Adds the snippet to the .gitignore file in the current working
    # directory in case it exists and the given snippet identifier matched
    # exactly one snippet.
    def add
      snippets = fetch(ARGV[1])
      if snippets.length < 1
        error "No snippets found for '#{ARGV[1]}'", 1
      elsif snippets.length > 1
        error "Multiple possible snippets found for '#{ARGV[0]}'.", 1
        error "Please be more specific.", 1
        snippets.each do |f|
          notice f, 2
        end
      else
        performAdd(snippets.first)
      end
    end

    # Adds the given snippet in case the .gitignore file exists.
    def performAdd(snippet)
      if not File.exists?(".gitignore")
        error "No .gitignore file found in working directory.", 1
      else
        notice "Adding Snippet '#{snippet}'.", 1

        f = File.new(".gitignore", "a")
        snippetData = fetchFile(snippet)
        f.write("\n\n# Added by gemignore. Snippet '#{snippet}'\n" + snippetData)
        f.close

        msg "Successfully added snippet.", 1
      end
    end

    # Creates a Regexp for the given string. Will be case-insensitive if the
    # input does not contain any uppercase characters. Wildcards are
    # added before and after the input, so the regex will match anything containing
    # the input, or the input itself.
    def regexpForInput(input)
      return (/(.*)/) if not input
      input = Regexp.escape(input)
      opt = input =~ /[A-Z]/ ? nil : Regexp::IGNORECASE;
      Regexp.new("(.*#{input}.*)", opt)
    end

    # Fetches the list of available snippets via the GitHub API
    #--
    # FIXME: Do some (url) refactoring
    #++
    def fetch(search = nil)
      search = regexpForInput(search)
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