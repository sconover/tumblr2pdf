module SaveableAsPdf
  def save_to(pdf_file_path)
    doc = PdfDocument.new 
    write_on(doc)
    doc.save_to(pdf_file_path)
  end
end
