require "rubygems"
require "json"
require "open-uri"
require "benchmark"

def require_dir(dir)
  Dir["#{dir}/**/*.rb"].each do |file|
    require file
  end
end

require_dir "lib/core"


