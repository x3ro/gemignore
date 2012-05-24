require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

GEMIGNORE_PATH = "../bin/gemignore"

describe "Gemignore" do

  # Basic usage tests

  it "should not throw an error when listing all snippets" do
    lambda { GemIgnore::Main.new.dispatch(["l"]) }.should_not raise_error
    lambda { GemIgnore::Main.new.dispatch(["list"]) }.should_not raise_error
  end

  it "should not throw an error when peeking into a snippet" do
    lambda { GemIgnore::Main.new.dispatch(["p", "Actionscript"]) }.should_not raise_error
    lambda { GemIgnore::Main.new.dispatch(["peek", "Actionscript"]) }.should_not raise_error
  end

  it "should not throw an error when search for a snippet" do
    lambda { GemIgnore::Main.new.dispatch(["search", "lin"]) }.should_not raise_error
    lambda { GemIgnore::Main.new.dispatch(["s", "lin"]) }.should_not raise_error
  end

  it "should be able to successfully add all snippets" do
    # Change CWD to tests/ so that we don't accidentally modify another .gitignore file
    Dir.chdir(File.dirname(__FILE__))

    # Clear potential old .gitignore file
    File.delete('.gitignore') if File.exists?('.gitignore')
    File.new('.gitignore', 'w')

    gemignore = GemIgnore::Main.new
    snippets = gemignore.fetch('')  # Get all snippets

    gitignoreLines = 0 # File should be empty, we created it in #setup
    gitignoreCommentLength = gemignore.gitignoreCommentForSnippet('foobar').split("\n").length

    snippets.each do |snippet|
      puts %x[#{GEMIGNORE_PATH} add #{snippet}]

      gitignore = File.readlines('.gitignore')

      # Make sure that adding the snippet did actually add something to the file
      (gitignore.length >= (gitignoreLines + gitignoreCommentLength)).should be true
      gitignoreLines = gitignore.length

      # Asserting that there is not HTML in the added snippet, which would mean there
      # was a 404 error when fetching the snippet.
      gitignore.grep(/<html>/).should be_empty
    end
  end



  # Error scenarios

  it "should throw an error when a wrong subcommand is passed" do
    lambda { GemIgnore::Main.new.dispatch(["foobarbaz"]) }.should raise_error(GemIgnore::CommandError)
  end

  it "should throw an error when no subcommand is passed" do
    lambda { GemIgnore::Main.new.dispatch([]) }.should raise_error(GemIgnore::CommandError)
  end



  # Low - level tests

  it "should fetch the file list without .gitignore extension" do
    x = GemIgnore::Main.new.fetch
    x.each { |i| i.split('.').last.should_not eq('gitignore') }
  end

end
