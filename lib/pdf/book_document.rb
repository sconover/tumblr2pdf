class BookDocument
  def initialize(pdf=PdfDocument.new)
    @pdf = pdf
  end
  
  def passage(text)
    passage_style = {
      :font_size => 10,
      :line_size => 13,
  
      :text_x_offset => 200,
      :text_width => 300
    }
    text = text.gsub("\n\n\342\200\246\n\n", "\n\342\200\246\n")
    text = text.gsub("\n\n...\n\n", "\n...\n")
    paragraphs = text.split("\n\n").collect{|p|p + "\n\n"}
    paragraphs.last.strip! if paragraphs.length>0
    paragraphs.each do |p|
      @pdf.try_to_fit_on_same_page{|doc|doc.text(p, passage_style)}
    end
  end
  
  def citation(text)
    citation_style = {
      :font_size => 10,
      :line_size => 13,
  
      :text_x_offset => 220,
      :text_width => 280,
      :font => "Times-Italic"
    }
    
    @pdf.try_to_fit_on_same_page{|doc|doc.text(text, citation_style)}
  end
  
  def save_to(path)
    @pdf.save_to(path)
  end
end