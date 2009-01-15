require "lib/book"
require "spec"

describe Passage do

  it "writes passage" do
    passage = Passage.new(
      :text => "There once was a frog",
      :source => "NYT",
      :when => Time.parse("2008-02-03 12:23:56"))
    
    pdf = passage.save_to("/tmp/book.pdf")
    pdf.text.should include("There once was a frog")
    pdf.text.should include("NYT")
    pdf.text.should include("Feb 3")
  end
  
end