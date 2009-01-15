class String
  def html_to_plain_text
    str = Hpricot(self).to_plain_text
    first_alpha = str.index(/[a-zA-Z0-9]/)
    str = str.slice(first_alpha..str.length)
    str
  end
end