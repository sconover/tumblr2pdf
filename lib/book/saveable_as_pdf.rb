module SaveableAsPdf
  def save_to(pdf_file_path)
    doc = BookDocument.new 
    write_on(doc)
    doc.save_to(pdf_file_path)
  end
end
