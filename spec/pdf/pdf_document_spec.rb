require "lib/pdf"
require "spec"
require "spec/pdf/fake_pdf"

describe PdfDocument, "for real" do
  before do
    @doc = PdfDocument.new
  end

  it "writes a title" do
    @doc.text("The Title")
    
    pdf = @doc.save_to("/tmp/doc.pdf")
    pdf.text.should include("The Title")
  end
end

describe PdfDocument, "write line" do
  it "writes lines" do
    fake_pdf = FakePdf.new
    doc = PdfDocument.new(fake_pdf)
    
    doc.text("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16")
    fake_pdf.pages.should == [
      [
        "1 2 3 4 5",
        "6 7 8 9 10",
        "11 12 13 14 15",
        "16",
      ]
    ]
  end
  
  it "respects newline commands" do
    fake_pdf = FakePdf.new
    doc = PdfDocument.new(fake_pdf)
    
    doc.text("1 2 3\n4 5 6 7 8 9")
    fake_pdf.pages.should == [
      [
        "1 2 3",
        "4 5 6 7 8",
        "9"
      ]
    ]
  end

  it "respects newline commands - more than one" do
    fake_pdf = FakePdf.new
    doc = PdfDocument.new(fake_pdf)
    
    doc.text("1 2 3\n\n4 5 6 7 8 9")
    fake_pdf.pages.should == [
      [
        "1 2 3",
        "",
        "4 5 6 7 8",
        "9"
      ]
    ]
  end

  
  it "respects newline commands (ignored when aligned with EOL)" do
    fake_pdf = FakePdf.new
    doc = PdfDocument.new(fake_pdf)
    
    doc.text("1 2 3 4 5\n6 7 8 9")
    fake_pdf.pages.should == [
      [
        "1 2 3 4 5",
        "6 7 8 9"
      ]
    ]
  end


  
  it "page advances" do
    fake_pdf = FakePdf.new
    doc = PdfDocument.new(fake_pdf, 90)
    
    doc.text("1 2 3 4 5 6 7 8 9 10")
    doc.text("1 2 3 4 5 6 7 8 9 10")
    doc.text("1 2 3 4 5 6 7 8 9 10")
    doc.text("1 2 3")
    fake_pdf.pages.should == [
      [
        "1 2 3 4 5",
        "6 7 8 9 10"
      ],
      [
        "1 2 3 4 5",
        "6 7 8 9 10"
      ],
      [
        "1 2 3 4 5",
        "6 7 8 9 10"
      ],
      [
        "1 2 3"
      ]
    ]
  end

end

# describe "fits_on_current_page" do
#   it "doesn't really write lines.  returns estimate." do
#     fake_pdf = FakePdf.new
#     doc = PdfDocument.new(fake_pdf)
#     
#     doc.text("x x x")
#     
#     doc.estimate { text("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16") }.should == 80
#     
#     fake_pdf.pages.should == [["x x x"]]
#     
#     doc.text("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16")
#     
#     fake_pdf.pages.should == [
#       [
#         "x x x",
#         "1 2 3 4 5",
#         "6 7 8 9 10",
#         "11 12 13 14 15",
#         "16",
#       ]
#     ]
#   end
#   
#   it "across pages" do
#     fake_pdf = FakePdf.new
#     doc = PdfDocument.new(fake_pdf, 90)
#     
#     doc.estimate { doc.text("1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16") }.should == 80
#     fake_pdf.pages.should == []
#   end
# 
# end

describe "try to get it all on the same page" do
  before do
    @fake_pdf = FakePdf.new
    @doc = PdfDocument.new(@fake_pdf, 90)
  end
  
  it "simple" do
    
    @doc.try_to_fit_on_same_page("1 2 3 4")
    
    @fake_pdf.pages.should == [
      [
        "1 2 3 4"
      ]
    ]
  end
  
  it "try to fit on one page" do
    
    @doc.text("1 2 3 4")
    
    @fake_pdf.pages.should == [
      [
        "1 2 3 4"
      ]
    ]
    
    @doc.try_to_fit_on_same_page("a b c d e f g")
    
    @fake_pdf.pages.should == [
      [
        "1 2 3 4"
      ],
      [
        "a b c d e",
        "f g"
      ]
    ]
    
    @doc.text("1 2 3 4")
    @doc.try_to_fit_on_same_page("1 2 3 4 5 6 7 8 9 10 11 12")
    
    @fake_pdf.pages.should == [
      [
        "1 2 3 4"
      ],
      [
        "a b c d e",
        "f g"
      ],
      [
        "1 2 3 4"
      ],
      [
        "1 2 3 4 5",
        "6 7 8 9 10",
      ],
      [
        "11 12"
      ]
    ]
  end
end