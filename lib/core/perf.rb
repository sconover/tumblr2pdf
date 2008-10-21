module Perf

  def self.time(name="")
    puts name + Benchmark.measure { yield }.to_s
  end

  def self.profile
    require 'ruby-prof'

    RubyProf.start

    result = yield

    result = RubyProf.stop
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT, 0)

    result
  end

end