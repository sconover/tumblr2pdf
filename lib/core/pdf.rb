class PdfInspector
  
  def initialize(pdf_path)
    @pdf_path = pdf_path
  end
  
  def text
    unless @text
      `pdftotext #{@pdf_path} /tmp/pdf_to_text_out.txt`
      @text = File.read("/tmp/pdf_to_text_out.txt")
    end
    @text
  end
  
end