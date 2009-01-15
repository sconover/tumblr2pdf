module SaveableAsPdf
  def save_to(pdf_file_path)

    doc = Prawn::Document.new
    
    write_on(doc)
    
    doc.render_file(pdf_file_path)
    
    PdfInspector.new(pdf_file_path)
  end
end