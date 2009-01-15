class Blog


  #future: "download"?
  def self._blog_get(tumblr_service, site, start, num)
    JSON.parse(tumblr_service.get(@site, 0,0).sub("var tumblr_api_read = ", "").strip.sub(/;$/, ""))
  end

  def self.load(site, tumblr_service=TumblrService.new)
    Blog.new(_blog_get(tumblr_service, site, 0, 0)["posts"].collect do |post_json|
      
      converted = {}
      post_json.each do |attribute, value|
        if attribute == "type"
          converted["post_type"] = value
        else
          converted[attribute.gsub("-", "_")] = value
        end
      end
      
      Post.new(converted)
    end)
  end
  
  
  attr_reader :posts
  
  def initialize(posts)
    @posts = posts
  end
  
  
  def write_pdf_to(path)

    doc = Prawn::Document.new
    posts.each do |post|
      if post.post_type == "quote"
        doc.text(post.quote_text)
      end
    end
    
    doc.render_file(path)
    
    PdfInspector.new(path)
  end
  
  def write_tmp_pdf
    write_pdf_to("/tmp/test.pdf")
  end
  
end