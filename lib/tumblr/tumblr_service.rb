class TumblrService  
  def get(site)
    total_posts = _json_request(site, 0, 1)["posts-total"].to_i
    posts_per_call = 50
    
    calls = total_posts / posts_per_call + 1
    
    posts = []
    (0..calls).each do |call|
      posts << _json_request(site, call*posts_per_call, posts_per_call)["posts"]
    end
    
    posts.flatten
  end
  
  def _json_request(site, start, num)
    JSON.parse(`curl -s "http://#{site}/api/read/json?start=#{start}&num=#{num}"`.sub("var tumblr_api_read = ", "").strip.sub(/;$/, ""))
  end
end