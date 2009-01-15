require "lib/book"
require "spec"

describe Chapter do

  it "writes name" do
    chapter = Chapter.new("January")
    
    chapter.save_to("/tmp/book.pdf").text.should include("January")
  end
  
  it "writes quote" do
    chapter = Chapter.new("January")
    chapter.quote(Quote.from_fixture("mccain_quote"))
    
    pdf = chapter.save_to("/tmp/book.pdf")
    
    pdf.text.should include("one of the most well-known conservative")
    pdf.text.should include("Anger on the Right at McCain")
  end
  
  
end