require "lib/tumblr"
require "spec/tumblr/fake_tumblr_service"
require "spec"

describe Quote do
  
  
  it "writes to pdf" do
    quote = Quote.from_json_hash(
      JSON.parse(File.read("spec/tumblr/sampledata/mccain_quote.json"))
    )
    
    pdf = quote.save_to("/tmp/book.pdf")
    pdf.text.should include("one of the most well-known conservative")
    pdf.text.should_not include("<p>")
    pdf.text.should_not include("&#8220;")
    pdf.text.should_not include("</p>")
    
    pdf.text.should include("Anger on the Right at McCain - The Washington Note [http://www.thewashingtonnote.com/archives/2008/10/anger_on_the_ri/]")
    
    pdf.text.should include("Oct 18")
  end
end
