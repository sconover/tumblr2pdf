require "lib/book"
require "spec"

describe Book do

  it "writes a title" do
    
    book = Book.new("Foo in 2008")
    
    pdf = book.save_to("/tmp/book.pdf")
    pdf.text.should include("Foo in 2008")
  end
  
  it "writes a chapter" do
    
    book = Book.new
    book.chapter(Chapter.new("January"))
    
    pdf = book.save_to("/tmp/book.pdf")
    pdf.text.should include("January")
  end
end