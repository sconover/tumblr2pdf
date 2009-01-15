require "lib/book"
require "spec"

describe Passage do

  it "writes passage" do
    passage = Passage.new(:text => "There once was a frog")
    
    passage.save_to("/tmp/book.pdf").text.should include("There once was a frog")
  end
  
end