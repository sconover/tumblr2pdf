require "lib/pdf"
require "spec"

describe PdfDocument do
  before do
    @doc = PdfDocument.new
  end

  it "writes a title" do
    @doc.title("The Title")
    
    pdf = @doc.save_to("/tmp/doc.pdf")
    pdf.text.should include("The Title")
  end
end