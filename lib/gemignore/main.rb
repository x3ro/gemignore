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

      (help; return) if ARGV.length === 0

      cmd = ARGV.shift # get the sub-command
      case cmd
        when "list"
          list
        when "search"
          search
        when "add"
          add
        when "help"
          help
        else
          error "Unknown gemignore command '#{cmd}'."
          notice "Run 'gemignore help' to display usage information."
      end

    end

    # Displays some usage information
    def help
      notice <<-BANNER
gemignore - .gitignore snippet utility
usage: gemignore <command> <input>

Available commands are:
  list    Lists all available snippets
  search  Searches for snippets containing <input>
  add     Add a snippet to the .gitignore file in your working directory
  help    Display this message
BANNER
    end

    # Check if there is an case insensitive match in the fetched snippet list, in which
    # case a list containing only that snippet is returned. Otherwise, the entire list
    # of snippets is retuned unmodified.
    def searchExactMatch(snippets, keyword)
      keyword = keyword.downcase
      index = snippets.find_index { |x| x.downcase == keyword }
      if index.nil?
        snippets
      else
        [ snippets[index] ]
      end
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
      results = fetch(ARGV[0])
      if(results.length < 1)
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
      keyword = ARGV[0]
      snippets = fetch(keyword)
      snippets = searchExactMatch(snippets, keyword)
      if snippets.length < 1
        error "No snippets found for '#{keyword}'", 1
      elsif snippets.length > 1
        error "Multiple possible snippets found for '#{keyword}'.", 1
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
      url = URI.parse("https://raw.github.com/github/gitignore/master/#{snippet}.gitignore")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"  # enable SSL/TLS

      data = ""
      http.start do
        http.request_get(url.path) do |res|
          data = res.body
        end
      end

      data
    end
  end



end
