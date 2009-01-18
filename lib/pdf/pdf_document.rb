
class PdfDocument
  
  
  def initialize(doc=PDF::Writer.new, page_height=756 )
    @doc = doc
    @doc.select_font("Times-Roman", {:encoding => "MacRomanEncoding"}) 
    
    @page = Page.new(doc, page_height)    
  end    
  
  def try_to_fit_on_same_page(text, style={})
    style_to_use = Page::DEFAULT_STYLE.merge(style)
    
    if @page.fits?(text, style_to_use)
      text(text, style_to_use)
    else
      @page = @page.next
      text(text, style_to_use)
    end
  end
  
  def text(text, style={})
    
    style_to_use = Page::DEFAULT_STYLE.merge(style)
    
    remaining_text = text
    while (!remaining_text.nil?)
      
      if @page.full?(style_to_use)
        @page = @page.next
      end
      
      @page.new_line_if_necessary(style_to_use[:line_size])
      
      remaining_text = @page.write_line(remaining_text, style_to_use)
    end
  end
  
  def save_to(path)
    File.open(path, "w+") { |f| f.write @doc.render } 
    PdfInspector.new(path)
  end
end