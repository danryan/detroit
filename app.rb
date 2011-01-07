module Detroit
  class App < Sinatra::Base    
    configure(:development) do
      register Sinatra::Reloader
    end
    
    RRD_PATH = "#{File.dirname(__FILE__)}/data/rrd/"
    
    get "/hosts" do
      hosts = Dir.glob("#{RRD_PATH}/*").map { |h| File.basename(h) }
      { :hosts => hosts }.to_json
    end
    
    get "/hosts/:host" do
      host = params[:host].gsub("_",".")
      plugins = Dir.glob("#{RRD_PATH}/#{host}/*").map { |p| File.basename(p) }
      { :host => host, :plugins => plugins }.to_json
    end
    
    get "/hosts/:host/:plugin" do
      host = params[:host].gsub("_",".")
      plugin = params[:plugin]
      metrics = Dir.glob("#{RRD_PATH}/#{host}/#{plugin}/*.rrd").map do |m|
        File.basename(m).sub(".rrd","")
      end
      { :host => host, :plugin => plugin, :metrics => metrics }.to_json
    end
    
    get "/hosts/:host/:plugin/:metric" do
      host = params[:host].gsub("_",".")
      plugin = params[:plugin]
      metric = params[:metric]
      data = get_data(host, plugin, metric)
      { :host => host, :plugin => plugin, :metric => metric, :data => data}.to_json
    end
    
    private
    
    def get_data(host, plugin, metric, options={})
      rrd = RRD::Base.new(File.join(RRD_PATH, host, plugin, "#{metric}.rrd"))
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

