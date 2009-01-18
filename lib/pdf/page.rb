
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
    @doc.start_new_page
    Page.new(@doc, @page_height)
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
  
  def fits?(text, style)
    @test_mode = true
    current_line_full_before = @current_line_full
    pointer_before = @pointer
    
    remaining_text = text
    while (!remaining_text.nil? && !full?(style))
      new_line_if_necessary(style[:line_size])
      remaining_text = write_line(remaining_text, style)
    end
    
    @current_line_full = current_line_full_before
    @pointer = pointer_before
    @test_mode = false
    
    remaining_text == nil
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