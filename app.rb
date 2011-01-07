module Detroit
  class App < Sinatra::Base    
    configure(:development) do
      register Sinatra::Reloader
    end
    
    def get_data(host, plugin, metric, options={})
      rrd = RRD::Base.new(File.join(RRD_PATH, host, plugin, "#{metric}.rrd"))
      start_at = options[:start_at] || rrd.starts_at
      end_at = options[:end_at] || rrd.ends_at
      results = rrd.fetch(:average, :start => start_at, :end => end_at)
      r = Array.new
      
      index = results.shift
      index.each do |i|
        r << {:label => i, :data => [] }
      end
      
      results.each do |line|
        line.map! { |a| a.kind_of?( Fixnum ) ? a : 0 }
        index.each_with_index do |v,i|
          r[i][:data] << line[i]
        end
      end
      r
    end
    
    RRD_PATH = "#{File.dirname(__FILE__)}/data/rrd/"
    
    get "/" do
      @hosts = Dir.glob("#{RRD_PATH}/*").map { |h| File.basename(h) }
      haml :index
    end
    
    get "/:host" do
      
      @host = params[:host]
      @plugins = Dir.glob("#{RRD_PATH}/#{@host}/*").map { |p| File.basename(p) }
      haml :host
    end
    
    get "/:host/:plugin" do
      @host = params[:host]
      @plugin = params[:plugin]
      @metrics = Dir.glob("#{RRD_PATH}/#{@host}/#{@plugin}/*.rrd").map do |m|
        File.basename(m).sub(".rrd","")
      end
      haml :plugin
    end

    
    get "/:host/:plugin/:metric" do
      # content_type :json
      @host = params[:host]
      @plugin = params[:plugin]
      @metric = params[:metric]
      data = get_data(@host, @plugin, @metric)
      # {:one => 1, :two => 2}.to_json
      data.to_json
    end
  end
end

