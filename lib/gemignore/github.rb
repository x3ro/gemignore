require 'octokit'
require 'base64'
require 'tmpdir'
require 'json'

# This class implements the necessary high-level operations we need to perform on the
# GitHub API and caches them. "High-level", because most of them are already pre-processed
# to fit what is needed in gemignore, whereas "low-level" operations are those directly
# performed on the GitHub API
#
class GitHub

  CACHE_LIFETIME = 60 * 30 # seconds

  # Path to our temporary cache file
  @tmpFile = Dir.tmpdir + '/' + 'gemignoretemp'


  # Try to load cache from temporary file
  if File.exists? @tmpFile
    @cache = JSON.parse(File.open(@tmpFile,'rb').read)
    @cache = nil if (Time.now.to_i - @cache["creationTime"]) > CACHE_LIFETIME
  end

  @cache ||= { "creationTime" => Time.now.to_i }

  # Used to write the cache object to a temporary file when the program
  # exits. We try to load the cache object from the file when this class is created.
  at_exit {
    File.open(@tmpFile, 'w').write(JSON.generate(@cache))
  }

  # Retrieve the full list of files available inside the given repository + tree.
  #
  def self.fileList(repo, tree_sha)
    idArray = ["fileList", repo, tree_sha]
    cache = readCache(idArray)
    return cache if not cache.nil?

    tree = Octokit.tree(repo, tree_sha, :recursive => 1).tree
    writeCache(idArray, Hash[*tree.flat_map { |t| [t.path, t.sha] }])
  end


  # Retrieves a file's contents identified by its blob's SHA hash
  #
  def self.getFile(repo, sha)
    idArray = ['getFile', repo, sha]
    cache = readCache(idArray)
    return cache if not cache.nil?

    res = Octokit.blob(repo, sha)
    data = nil
    case res.encoding
      when "base64"
        data = Base64.decode64(res.content)
      when "utf-8"
        data = res.content
      else
        raise NotImplementedError.new("Could not decode response from GitHub API")
    end
    self.writeCache(idArray, data)
  end


  private

  # Write a value to our cache object.
  def self.writeCache(idArray, value)
    raise ArgumentError.new("idArray parameter must be an array") if not idArray.is_a? Array
    id = idArray.join("$")

    if value.is_a? String
      value = value.force_encoding("UTF-8")
    end

    @cache[id] = value
  end


  def self.readCache(idArray)
    id = idArray.join("$")
    @cache[id]
  end

end

