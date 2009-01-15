class Quote
  
  def self.from_json_hash(h)
    Quote.new(
      :text => h["quote-text"].strip,
      :when => Time.parse(h["date"]),
      :url => h["url"],
      :source => h["quote-source"].html_to_plain_text
    )
  end
  
  def initialize(args)
    required = [:text, :url, :when, :source]
    setup_named_params(args, {}, required)
  end
  
  def to_passage
    Passage.new(:text => @text, :source => @source, :when => @when, :url => @url)
  end
end