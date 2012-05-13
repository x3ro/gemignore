require 'rubygems'
require 'rainbow'
require 'net/http'
require 'net/https'
require 'json'


module GemIgnore

  #--
  # FIXME: Not a good name, but for now its okay
  # FIXME: Add documentation
  # FIXME: Cleanup code
  #++
  class Main

    include Util

    def initialize
      @snippetRepository = 'github/gitignore'
      @snippetBranch = 'master'
    end

    def dispatch

      (help; return) if ARGV.length === 0

      cmd = ARGV.shift # get the sub-command
      case cmd
        when "list"
          list
        when "search"
          (help; exit) if ARGV.empty?
          search(ARGV.dup)
        when "add"
          (help; exit) if ARGV.empty?
          add(ARGV.dup)
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

    # Returns the comment that is added before a gitignore snippet
    def gitignoreCommentForSnippet(snippet)
      "\n\n# Added by gemignore. Snippet '#{snippet}'\n"
    end

    # Displays a list of available .gitignore snippets
    def list
      msg "Available .gitignore snippets:", 1
      fetch().each do |f|
        notice f, 2
      end
    end

    # Searches for a given snippet name
    def search(args)
      keyword = args.shift
      results = fetch(keyword)

      if(results.length < 1)
        error "No snippets found for '#{keyword}'", 1
      else
        msg "Snippets found for '#{keyword}':", 1
        results.each do |f|
          notice f, 2
        end
      end

      search(args) if not args.empty?
    end

    # Adds the snippet to the .gitignore file in the current working
    # directory in case it exists and the given snippet identifier matched
    # exactly one snippet.
    def add(args)
      keyword = args.shift
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

      add(args) if not args.empty?
    end

    # Adds the given snippet in case the .gitignore file exists.
    def performAdd(snippet)
      if not File.exists?(".gitignore")
        error "No .gitignore file found in working directory.", 1
      else
        notice "Adding Snippet '#{snippet}'.", 1

        f = File.new(".gitignore", "a")
        snippetData = fetchFile(snippet)
        f.write(gitignoreCommentForSnippet(snippet) + snippetData)
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
    #
    def fetch(search = nil)
      search = regexpForInput(search)

      files = GitHub.fileList(@snippetRepository, @snippetBranch).keys
      files.map! do |f|
        t = f.split('.')
        (t.pop; t.join('.') =~ search; $1) if t.last === 'gitignore'
      end
      files.compact
    end

    # Fetches a snippet file from GitHub
    #
    def fetchFile(snippet)
      files = GitHub.fileList(@snippetRepository, @snippetBranch)
      sha = files["#{snippet}.gitignore"]

      raise ArgumentError.new("No gitignore snippet matching '#{snippet}' found") if sha.nil?

      GitHub.getFile(@snippetRepository, sha)
    end
  end



end
