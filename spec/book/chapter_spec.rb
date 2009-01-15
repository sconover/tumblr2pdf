require "lib/book"
require "spec"

describe Chapter do

  it "writes name" do
    chapter = Chapter.new("January")
    
    chapter.save_to("/tmp/book.pdf").text.should include("January")
  end
  
end