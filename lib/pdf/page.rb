
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
  
  def initialize(doc, page_height)
    @doc = doc
    
    @page_height = page_height - page_height % 20
    
    @pointer = @page_height
    @test_mode = false
    new_line
  end

  def next
    @doc.start_new_page
    Page.new(@doc, @page_height)
  end

  def enough_room?(points)
    @pointer >= points
  end

  def at_the_bottom?
    @pointer == 40
  end
  
  def full?
    at_the_bottom? && @current_line_full
  end
  
  def new_line_if_necessary
    new_line if @current_line_full
  end
  
  def new_line
    @pointer -= 20
    @current_line_full = false
  end
  
  def fits?(text)
    @test_mode = true
    current_line_full_before = @current_line_full
    pointer_before = @pointer
    
    remaining_text = text
    while (!remaining_text.nil? && !full?)
      new_line_if_necessary
      remaining_text = write_line(remaining_text)
    end
    
    @current_line_full = current_line_full_before
    @pointer = pointer_before
    @test_mode = false
    
    remaining_text == nil
  end
  
  def write_line(some_text)
    some_text = CONVERTER.iconv(some_text)
    raise "not enough room for #{line_of_text}" if full?

    what_would_remain = @doc.add_text_wrap(50, @pointer, 400, some_text, nil, :left, 0, true)
    length_written = some_text.length - what_would_remain.length
    
    remaining_text = 
      if (some_text.slice(0..length_written).include?("\n"))
        eol_pos = some_text.index("\n")
        @doc.add_text_wrap(50, @pointer, 400, some_text.slice(0..eol_pos).strip, nil, :left, 0, @test_mode)
        result = some_text.slice(eol_pos+1..some_text.length)
        result=="" ? nil : result
      else
        result = @doc.add_text_wrap(50, @pointer, 400, some_text, nil, :left, 0, @test_mode)
        result=="" ? nil : result
      end
    
    @current_line_full = true
    
    remaining_text
  end
  
end