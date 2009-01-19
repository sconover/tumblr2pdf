
class PdfDocument
  
  attr_reader :pages_used
  
  def initialize(doc=PDF::Writer.new, page_height=756 )
    @doc = doc
    @page_height = page_height
    @page = Page.new(doc, page_height)
    @pages_used = 1
    
    @doc.select_font("Times-Roman", {:encoding => "MacRomanEncoding"}) 
  end    
  
  def advance_page
    @pages_used += 1
    @page = @page.next
  end
  
  def test_mode_clone
    doc = PdfDocument.new(@doc, @page_height)
    page = @page.test_mode_clone
    doc.instance_variable_set("@page".to_sym, page)
    doc
  end
  
  def would_fit_on_current_page?
    doc = test_mode_clone
    yield(doc)
    doc.pages_used==1
  end
  
  def try_to_fit_on_same_page(text, style={})
    style_to_use = Page::DEFAULT_STYLE.merge(style)
    
    if would_fit_on_current_page? {|doc|doc.text(text, style_to_use)}
      text(text, style_to_use)
    else
      advance_page
      text(text, style_to_use)
    end
  end
  
  def text(text, style={})
    
    style_to_use = Page::DEFAULT_STYLE.merge(style)
    
    remaining_text = text
    while (!remaining_text.nil?)
      
      if @page.full?(style_to_use)
        advance_page
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