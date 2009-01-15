class Chapter
  include SaveableAsPdf
  
  def initialize(name="")
    @name = name
  end
  
  def write_on(pdf)
    pdf.text(@name)
  end
end