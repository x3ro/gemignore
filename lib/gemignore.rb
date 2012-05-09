module GemIgnore
end

lib = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) if File.directory?(lib) && !$LOAD_PATH.include?(lib)

require 'gemignore/github'
require 'gemignore/main'
