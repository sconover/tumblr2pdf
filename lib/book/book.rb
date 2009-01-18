class Book
  include SaveableAsPdf
  
  def initialize(title="")
    @title = title
    @chapters = []
  end
  
  def chapter(another_chapter)
    @chapters << another_chapter
  end
  
  def fractional(fraction)
    book = Book.new(@title)
    @chapters.each {|c| book.chapter(c.fractional(fraction))}
    book
  end
  
  def write_on(pdf)
    pdf.text(@title)
    
    @chapters.each{|c|c.write_on(pdf)}
  end
end