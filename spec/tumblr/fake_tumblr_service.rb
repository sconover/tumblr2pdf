class FakeTumblrService
  def initialize(content)
    @content = content
  end
  
  def get(site, start, num)
    @content
  end
end