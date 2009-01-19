
require "iconv"
CONVERTER = Iconv.new( 'ISO-8859-15//IGNORE//TRANSLIT', 'utf-8')  
  
module PDF  
    class Writer  
        alias_method :old_text, :text  
  
        def text(textto, options = {})  
            old_text(CONVERTER.iconv(textto), options)  
        end  
  
    end  
end  


class Page
  
  DEFAULT_STYLE = {
    :font_size => 10,
    :line_size => 13,

    :text_x_offset => 200,
    :text_width => 300
  }
  
  def initialize(doc, page_height)
    @doc = doc
    
    @page_height = page_height
    
    @pointer = @page_height
    @test_mode = false
    @current_line_full = true
  end

  def next
    @doc.start_new_page unless @test_mode
    page = Page.new(@doc, @page_height)
    page.instance_variable_set("@test_mode", @test_mode)
    page
  end
  
  def test_mode_clone
    page = Page.new(@doc, @page_height)
    page.instance_variable_set("@pointer", @pointer)
    page.instance_variable_set("@test_mode", true)
    page.instance_variable_set("@current_line_full", @current_line_full)
    page
  end

  def enough_room?(points)
    @pointer >= points
  end

  def at_the_bottom?(style)
    @pointer <= style[:line_size]*2
  end
  
  def full?(style)
    at_the_bottom?(style) && @current_line_full
  end
  
  def new_line_if_necessary(line_size)
    new_line(line_size) if @current_line_full
  end
  
  def new_line(line_size)
    @pointer -= line_size
    @current_line_full = false
  end
  
  def write_line(some_text, style)
    some_text = CONVERTER.iconv(some_text)
    raise "not enough room for #{some_text}" if full?(style)

    what_would_remain = _add_text_wrap(some_text, style, true)
    length_written = some_text.length - what_would_remain.length
    
    remaining_text = 
      if (some_text.slice(0..length_written).include?("\n"))
        eol_pos = some_text.index("\n")
        _add_text_wrap(some_text.slice(0..eol_pos).strip, style)
        result = some_text.slice(eol_pos+1..some_text.length)
        result=="" ? nil : result
      else
        result = _add_text_wrap(some_text, style)
        result=="" ? nil : result
      end
    
    @current_line_full = true
    
    remaining_text
  end
  
  def _add_text_wrap(text, style, test_mode=@test_mode)
    font_before = @doc.current_font
    if (style[:font])
      @doc.select_font(style[:font])
    end
    
    result = @doc.add_text_wrap(
      style[:text_x_offset], 
      @pointer, 
      style[:text_width], 
      text, 
      style[:font_size], 
      :left, 
      0, 
      test_mode
    )
    
    if (style[:font])
      @doc.select_font(font_before)
    end
    
    result
  end
end