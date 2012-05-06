require 'octokit'

# This class implements the necessary high-level operations we need to perform on the
# GitHub API and caches them. "High-level", because most of them are already pre-processed
# to fit what is needed in gemignore.
#
class GitHub
  @cache = { }

  # Retrieve the full list of files available inside the given repository + tree.
  #
  def self.fileList(repo, tree_sha)
    idArray = ["fileList", repo, tree_sha]
    cache = readCache(idArray)
    return cache if not cache.nil?

    tree = Octokit.tree(repo, tree_sha, :recursive => 1).tree
    writeCache(idArray, tree.map { |t| t.path })
  end


  private


  def self.writeCache(idArray, value)
    raise ArgumentError.new("idArray parameter must be an array") if not idArray.is_a? Array
    id = idArray.join("$")
    @cache[id] = value
  end


  def self.readCache(idArray)
    id = idArray.join("$")
    @cache[id]
  end

end

