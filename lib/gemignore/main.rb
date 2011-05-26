require 'net/http'
require 'net/https'
require 'json'
require 'pp'


module GemIgnore

  # FIXME: Not a good name, but for now its okay
  # FIXME: Add documentation
  # FIXME: Cleanup code
  class Main

    def dispatch
      list if ARGV.length === 0
      search if ARGV.length === 1
      add if ARGV.length === 2 and ARGV[0] === "add"
    end

    def list
      puts "-> Available .gitignore snippets:"
      fetch().each do |f|
        puts "---> " + f
      end
    end

    def search
      puts "-> Snippets found for '#{ARGV[0]}':"
      fetch(regexpForInput(ARGV[0])).each do |f|
        puts "---> " + f
      end
    end

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
        tryPerformAdd(snippets.first)
      end
    end

    def tryPerformAdd(snippet)
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

    def regexpForInput(input)
      input = Regexp.escape(input)
      Regexp.new("(.*#{input}.*)", Regexp::IGNORECASE)
    end

    def fetch(search = nil)
      search = /(.*)/ if search === nil

      data = Net::HTTP.get( URI.parse('http://github.com/api/v2/json/blob/all/github/gitignore/master') )
      response = JSON.parse(data)
      files = response["blobs"].map { |k,v| k.split('.gitignore')[0] =~ search; $1  }
      files.compact
    end

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