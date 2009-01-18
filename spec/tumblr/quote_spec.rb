require "lib/tumblr"
require "spec/tumblr/fake_tumblr_service"
require "spec"

describe Quote do
  
  
  it "writes to pdf" do
    quote = Quote.from_fixture("mccain_quote")
    
    pdf = quote.save_to("/tmp/book.pdf")
    pdf.text.should include("one of the most well-known conservative")
    pdf.text.should_not include("<p>")
    pdf.text.should_not include("&#8220;")
    pdf.text.should_not include("</p>")
    
    pdf.text.should include("Anger on the Right at McCain")
    
    pdf.text.should include("Oct 18")
  end
end
