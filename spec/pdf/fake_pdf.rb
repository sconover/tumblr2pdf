class FakePdf
  
  attr_reader :pages
  
  def initialize
    @pages = []
    start_new_page
  end
  
  def select_font(*args) 
  end
  
  def start_new_page
    @pages << []
  end
  
  def current_page
    @pages.last
  end
  
  def add_text_wrap(x, y, width, text, size, justification, angle, test)
    count = 5
    index = 0
    while count > 0 && !index.nil?
      index = text.index(" ", index)
      index = index + 1 unless index.nil?
      count -= 1
    end
    
    
    this_line = text.slice(0..(index.nil? ? text.length-1 : index-2))
    
    current_page << this_line unless test
    text.slice((this_line.length+1)..text.length-1) || ""
  end
end