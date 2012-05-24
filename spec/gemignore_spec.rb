require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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
