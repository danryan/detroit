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
  data_dir = File.join(File.expand_path(File.dirname(__FILE__)), "data/rrd")
  xml_dir = File.join(File.expand_path(File.dirname(__FILE__)), "data/xml")
  
  desc "Build test RRDs from supplied XML files"
  task :build do
  %x[ 
    for i in `find #{xml_dir} -type d`
    do
      mkdir -p $(echo $i|sed 's/xml/rrd/')
    done

    for i in `find #{xml_dir} -iname '*.xml' -type f`
    do
      rrdtool restore $i $(echo $i | sed 's/xml/rrd/g')
    done
  ]
  end
  desc "Remove test RRD files"
  task :cleanup do
    %x[ for i in `find #{data_dir} -iname '*.rrd' -type f`; do rm $i; done ]
  end
  
  namespace :tmp do
    tmp_data_dir = File.join(File.expand_path(File.dirname(__FILE__)), "tmp/data/rrd")
    tmp_xml_dir = File.join(File.expand_path(File.dirname(__FILE__)), "tmp/data/xml")
    data_dir = File.join(File.expand_path(File.dirname(__FILE__)), "data/rrd")
    xml_dir = File.join(File.expand_path(File.dirname(__FILE__)), "data/xml")
    
    desc "Build test RRDs in ./tmp"
    task :copy => :build do
      %x[ 
          
        mkdir -p tmp/data/rrd
        cp -R #{data_dir}/* #{tmp_data_dir}
      ]
    end
    
    task :cleanup do
      %x[ for i in `find #{tmp_data_dir} -iname '*.rrd' -type f`; do rm $i; done ]
    end
  end
end