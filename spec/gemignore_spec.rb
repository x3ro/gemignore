require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Gemignore" do

  it "should fetch the file list without .gitignore extension" do
    x = GemIgnore::Main.new.fetch
    x.each { |i| i.split('.').last.should_not eq('gitignore') }
  end

end
