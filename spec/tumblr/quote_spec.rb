require "lib/tumblr"
require "spec/tumblr/fake_tumblr_service"
require "spec"

describe Quote do
  
  it "passage" do
    quote = Quote.from_json_hash(
      JSON.parse(File.read("spec/tumblr/sampledata/mccain_quote.json"))
    )
    
    passage = quote.to_passage
    
    passage.text.should include("&#8220;<p>one of the most well-known conservative")
    passage.url.should == "http://sconover.tumblr.com/post/55209760"
    passage.source.should == "Anger on the Right at McCain - The Washington Note [http://www.thewashingtonnote.com/archives/2008/10/anger_on_the_ri/]"
    passage.when.should == Time.parse("2008-10-18 15:35:18")
  end
end
