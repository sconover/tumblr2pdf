class Blog
  include SaveableAsPdf

  #future: "download"?
  def self._blog_get(tumblr_service, site)
    tumblr_service.get(site)
  end

  def self.load(site, tumblr_service=TumblrService.new)
    Blog.new(_blog_get(tumblr_service, site) \
      .select { |post_json| post_json.key?("quote-text") } \
      .collect do |post_json|
          Quote.from_json_hash(post_json)
        end)
  end
  
  
  attr_reader :posts
  
  def initialize(posts)
    @posts = posts
  end
  
  def to_book
    
    chapter = Chapter.new("Foo")
    @posts.each {|p| chapter.quote(p) }
    
    book = Book.new
    book.chapter(chapter)
    
    book
  end
  
end