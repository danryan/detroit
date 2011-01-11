require 'yaml'

module Detroit
  class App < Sinatra::Base
    # Did you remember to adjust config.yml to point to the right directory?
    CONFIG = YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
    # DATA_DIR = CONFIG['data_dir']
    # Comment the above line and uncomment the line below to use the test RRDs
    DATA_DIR = File.join(File.dirname(__FILE__), "data/rrd")
    
    configure(:development) do
      register Sinatra::Reloader
    end
    
    
    get "/hosts" do
      hosts = Dir.glob("#{DATA_DIR}/*").map { |h| File.basename(h) }
      { :hosts => hosts }.to_json
    end
    
    get "/hosts/:host" do
      host = params[:host]
      plugins = Dir.glob("#{DATA_DIR}/#{host}/*").map { |p| File.basename(p) }
      { :host => host, :plugins => plugins }.to_json
    end
    
    get "/hosts/:host/:plugin" do
      host = params[:host]
      plugin = params[:plugin]
      metrics = Dir.glob("#{DATA_DIR}/#{host}/#{plugin}/*.rrd").map do |m|
        File.basename(m).sub(".rrd","")
      end
      { :host => host, :plugin => plugin, :metrics => metrics }.to_json
    end
    
    get "/hosts/:host/:plugin/:metric" do
      host    = params.delete(:host)
      plugin  = params.delete(:plugin)
      metric  = params.delete(:metric)
      options = params      
      data = get_data(host, plugin, metric, options)
      { :host => host, :plugin => plugin, :metric => metric, :data => data}.to_json
    end
    
    
    private
    
    def get_data(host, plugin, metric, options={})
      rrd = RRD::Base.new(File.join(DATA_DIR, host, plugin, "#{metric}.rrd"))
      start_at = options[:start_at] || Time.now - 3600.seconds    # rrd.starts_at
      end_at = options[:end_at] || Time.now                       # rrd.ends_at
      results = rrd.fetch(:average, :start => start_at, :end => end_at)
      data = Array.new
      
      index = results.shift
      index.each do |i|
        data << {:label => i, :data => [] }
      end
      
      results.each do |line|
        line.map! {|a| a.respond_to?('nan?') ? ( a.nan? ? 0 : a ) : a }
        index.each_with_index do |v,i|
          data[i][:data] << line[i]
        end
      end
      data
    end
  end
end

