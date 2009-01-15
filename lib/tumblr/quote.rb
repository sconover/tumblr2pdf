class Quote
  include SaveableAsPdf
  
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
  
  def write_on(pdf)
    pdf.text(@text)
    pdf.text(@source)
    pdf.text(@when.strftime("%b") + " #{@when.day}")
  end
  
end