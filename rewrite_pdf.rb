raise "<dump file> <output pdf file>" unless ARGV.length == 2

require "lib/tumblr"


dump_file = ARGV[0]
pdf_file = ARGV[1]

book = Marshal.load(File.read(dump_file))
book.save_to(pdf_file)

system "open #{pdf_file}"