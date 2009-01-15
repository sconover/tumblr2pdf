class Chapter
  include SaveableAsPdf
  
  def initialize(name="")
    @name = name
    @quotes = []
  end
  
  def quote(another_quote)
    @quotes << another_quote
  end
  
  def write_on(pdf)
    pdf.text(@name)
    
    @quotes.each{|q| q.write_on(pdf)}
  end
  
end