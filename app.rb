module Detroit
  class App < Sinatra::Base    
    configure(:development) do
      register Sinatra::Reloader
    end
    
    def url
      "http://detroit.iamdanryan.com"
    end

    get "/hosts" do
      response = JSON.parse(RestClient.get("#{url}/hosts"))
      @hosts   = response["hosts"]
      haml :hosts

    end
    
    get "/hosts/:host" do
      host     = params[:host]
      response = JSON.parse(RestClient.get("#{url}/hosts/#{host}"))
      @host    = response["host"]
      @plugins = response["plugins"]
      haml :host

    end
    
    get "/hosts/:host/:plugin" do
      host     = params[:host]
      plugin   = params[:plugin]
      response = JSON.parse(RestClient.get("#{url}/hosts/#{host}/#{plugin}"))
      @host    = response["host"]
      @plugin  = response["plugin"]
      @metrics = response["metrics"]

      haml :plugin
    end
    
    get "/hosts/:host/:plugin/:metric" do
      host     = params[:host]
      plugin   = params[:plugin]
      metric   = params[:metric]
      response = JSON.parse(RestClient.get("#{url}/hosts/#{host}/#{plugin}/#{metric}"))
      @host    = response["host"]
      @plugin  = response["plugin"]
      @metric  = response["metric"]
      @data    = response["data"]
      haml :metric
    end

    get "/demos/load" do
      host = "test.example.com"
      plugin = "load"
      metric = "load"
      query = "?start_at=1294750000&end_at=1294753000"
      response = RestClient.get("#{url}/hosts/#{host}/#{plugin}/#{metric}#{query}")
      @data = JSON.parse(response)
      haml :load
    end
  end
end

