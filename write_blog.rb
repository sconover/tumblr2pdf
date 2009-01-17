raise "<site domain> <output pdf file>" unless ARGV.length == 2

require "lib/tumblr"


site = ARGV[0]
pdf_file = ARGV[1]

Blog.load(site, TumblrService.new).to_book.save_to(pdf_file)