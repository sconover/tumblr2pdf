require "lib/tumblr"
require "spec/tumblr/fake_tumblr_service"
require "spec"

describe Blog do
  
  before(:all) do
    @blog = Blog.load("sconover.tumblr.com", FakeTumblrService.new(File.read("spec/tumblr/sampledata/tumblr1.json")))
  end
  
  describe "get" do
    it "gets quote posts" do
      @blog.posts.pluck(:url).should == [
        "http://sconover.tumblr.com/post/55209760"
      ]
    end
  end
  
  
  describe "pdf" do
    
    it "basic" do
      pdf = @blog.to_book.save_to("/tmp/book.pdf")
      pdf.text.should include("one of the most well-known")
    end
    
  end
end
