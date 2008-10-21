require "lib/tumblr"
require "spec/tumblr/fake_tumblr_service"
require "spec"

describe Blog do
  
  before(:all) do
    @blog = Blog.load("sconover.tumblr.com", FakeTumblrService.new(File.read("spec/tumblr/sampledata/tumblr1.json")))
  end
  
  describe "get" do
    it "gets posts" do
      @blog.posts.pluck(:url).should == [
        "http://sconover.tumblr.com/post/55209760",
        "http://sconover.tumblr.com/post/55200403",
        "http://sconover.tumblr.com/post/55172522"
      ]
    end
  end
  
  
  describe "pdf" do
    
    it "basic" do
      pdf = @blog.write_tmp_pdf
      pdf.text.should include("one of the most well-known")
      pdf.text.should include("Bush Land about John McCain.")
    end
    
  end
end
