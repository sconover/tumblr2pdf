class Chapter
  include SaveableAsPdf
  
  def initialize(name="")
    @name = name
    @quotes = []
  end
  
  def quote(another_quote)
    @quotes << another_quote
  end
  
  def fractional(fraction)
    smaller = Chapter.new(@name)
    @quotes.slice(0..(@quotes.length.to_f/fraction.to_f).to_i + 1).each{|q|smaller.quote(q)}
    smaller
  end
  
  def write_on(doc)
    doc.text(@name)
    
    @quotes.each do |q| 
      q.write_on(doc)
    end
  end
  
end