#require "rubygems"
#require "lib/perftools"
#
#Perf.profile_requires do
  Dir["spec/**/*_spec.rb"].each do |file|
    require file
  end
#end
