raise "<site domain> <output pdf file>" unless ARGV.length == 2 || ARGV.length==3

require "lib/tumblr"


site = ARGV[0]
pdf_file = ARGV[1]
fraction = ARGV.length == 3 ? ARGV[2].to_i : nil


book_dump_file = "#{File.basename(pdf_file).split(".").first}"
book_dump_file += "_#{fraction}" if fraction
book_dump_file += ".book"

book = Blog.load(site, TumblrService.new).to_book
book = book.fractional(fraction) if fraction

File.open(book_dump_file, "w+") { |f| f << Marshal.dump(book) }

book.save_to(pdf_file) 