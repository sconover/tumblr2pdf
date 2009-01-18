
class PdfDocument
  
  
  def initialize(doc=PDF::Writer.new, page_height=756 )
    @doc = doc
    @doc.select_font("Times-Roman", {:encoding => "MacRomanEncoding"}) 
    
    @page = Page.new(doc, page_height)    
  end    
  
  def try_to_fit_on_same_page(text)
    if @page.fits?(text)
      text(text)
    else
      @page = @page.next
      text(text)
    end
  end
  
  def text(text)
    
    remaining_text = text
    while (!remaining_text.nil?)
      
      if @page.full?
        @page = @page.next
      else
        @page.new_line_if_necessary
      end

      
      remaining_text = @page.write_line(remaining_text)
    end
  end
  
  def save_to(path)
    File.open(path, "w+") { |f| f.write @doc.render } 
    PdfInspector.new(path)
  end
end