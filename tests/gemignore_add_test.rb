require 'test/unit'
require 'pathname'
require 'pp'

lib = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'gemignore'

GEMIGNORE_PATH = "../bin/gemignore"

class GemIgnoreAddTest < Test::Unit::TestCase

	def test_all_snippets
		gemignore = GemIgnore::Main.new
		snippets = gemignore.fetch('')	# Get all snippets

		gitignoreLines = 0 # File should be empty, we created it in #setup
		gitignoreCommentLength = gemignore.gitignoreCommentForSnippet('foobar').split("\n").length

		snippets.each do |snippet|
			puts %x[#{GEMIGNORE_PATH} add #{snippet}]

			gitignore = File.readlines('.gitignore')

			# Make sure that adding the snippet did actually add something to the file
			assert(gitignore.length >= (gitignoreLines + gitignoreCommentLength), "Adding Snippet #{snippet} didn't actually add anything")
			gitignoreLines = gitignore.length

			# Asserting that there is not HTML in the added snippet, which would mean there
			# was a 404 error when fetching the snippet.
			assert(gitignore.grep(/<html>/).empty?, "Adding Snippet #{snippet} failed (HTML in the .gitignore file)")
		end
	end

	def setup
		# Change CWD to tests/ so that we don't accidentally modify another .gitignore file
		Dir.chdir(File.dirname(__FILE__))

		# Clear potential old .gitignore file
		File.delete('.gitignore') if File.exists?('.gitignore')
		File.new('.gitignore', 'w')
	end

end
