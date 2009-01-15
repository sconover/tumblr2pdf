class Passage
  include SaveableAsPdf
  
  def initialize(args)
    defaults = {
      :url => "",
      :text => "",
      :when => Time.at(0),
      :source => ""
    }
    
    setup_named_params(args, defaults, [])
  end
  
  def write_on(pdf)
    pdf.text(@text)
    pdf.text(@source)
    pdf.text(@when.strftime("%b") + " #{@when.day}")
  end
end