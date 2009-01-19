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
      :source => h["quote-source"]
    )
  end
  
  def initialize(args)
    required = [:text, :url, :when, :source]
    setup_named_params(args, {}, required)
  end
  
  def formatted_when
    @when.strftime("%b") + " #{@when.day}"
  end
  
  def write_passage(doc)
    passage_style = {
      :font_size => 10,
      :line_size => 13,
  
      :text_x_offset => 200,
      :text_width => 300
    }
    text = @text.gsub("\n\n\342\200\246\n\n", "\n...\n")
    text = text.gsub("\n\n...\n\n", "\n...\n")
    
    paragraphs = text.split("\n...\n")
    paragraphs.slice(0..-2).each{|p|p << "\n...\n"}

    paragraphs = 
      paragraphs.collect do |p|
        inner_paragraphs = p.split("\n\n")
        inner_paragraphs.slice(0..-2).each{|p|p << "\n\n"}
        inner_paragraphs
      end.flatten
    
    if paragraphs.length>0
      paragraphs.slice(0..-2).each do |p|
        doc.try_to_fit_on_same_page{|doc|doc.text(p, passage_style)}
      end
      
      doc.try_to_fit_on_same_page do |doc|
        doc.text(paragraphs.last, passage_style)
        write_citation(doc)
      end
    end
  end
  
  def write_citation(doc)
    source = @source.gsub(/\[http.*\]/, "")
    
    citation_style = {
      :font_size => 10,
      :line_size => 13,
  
      :text_x_offset => 220,
      :text_width => 280,
      :font => "Times-Italic"
    }
    
    doc.try_to_fit_on_same_page do |doc|
      doc.text("\n" + source + "\n\n\n\n", citation_style)
    end
  end
  
  def write_on(doc)
    doc.text(formatted_when)
    write_passage(doc)
  end
  
end