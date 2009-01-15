class PdfDocument
  def initialize
    @prawn_doc = Prawn::Document.new
  end
  
  def title(title)
    @prawn_doc.text(title)
  end
  
  def save_to(path)
    @prawn_doc.render_file(path)
    PdfInspector.new(path)
  end
end