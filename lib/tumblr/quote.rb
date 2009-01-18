class Quote
  include SaveableAsPdf
  
  def self.from_fixture(name)
    from_json_hash(
      JSON.parse(File.read("spec/tumblr/sampledata/#{name}.json"))
    )
  end
  
  def self.from_json_hash(h)
    Quote.new(
      :text => h["quote-text"].html_to_plain_text.strip,
      :when => Time.parse(h["date"]),
      :url => h["url"],
      :source => h["quote-source"].html_to_plain_text
    )
  end
  
  def initialize(args)
    required = [:text, :url, :when, :source]
    setup_named_params(args, {}, required)
  end
  
  def formatted_when
    @when.strftime("%b") + " #{@when.day}"
  end
  
  def paragraphs
    @text.split("\n\n")
  end
  
  def write_on(pdf)
    paragraphs.each{|p|pdf.try_to_fit_on_same_page(p.strip + "\n\n")}
    pdf.try_to_fit_on_same_page(@source)
    pdf.text(formatted_when)
  end
  
end