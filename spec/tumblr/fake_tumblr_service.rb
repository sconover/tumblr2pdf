class FakeTumblrService
  def initialize(content)
    @content = content
  end
  
  def get(site)
    JSON.parse(@content.sub("var tumblr_api_read = ", "").strip.sub(/;$/, ""))["posts"]
  end
end