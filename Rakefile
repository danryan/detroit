require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

namespace :detroit do
  desc "Build test RRDs from supplied XML files"
  task :build_rrds
  DATA_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "data/rrd")
  XML_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "data/xml")
  %x[ 
    for i in `find #{XML_DIR} -type d`
    do
      mkdir -p $(echo $i|sed 's/xml/rrd/')
    done
  
    for i in `find #{XML_DIR} -iname '*.xml' -type f`
    do
      rrdtool restore $i $(echo $i | sed 's/xml/rrd/g')
    done
  ]
  
  desc "Clean up test RRD files"
  task :cleanup_rrds
  %x[
    for i in `find #{DATA_DIR} -iname '*.rrd' -type f`
    do
      rm $i
    done
  ]
  
end