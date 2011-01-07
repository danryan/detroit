def self.get_data(start_date, end_date, options, repository_options)
  rrd = RRD::Base.new(File.join(repository_options[:path],data_dir))
  results = rrd.fetch(:average, :start => start_date, :end => end_date)
  r = Array.new

  index = results.first.index(options[:rra])
  # Delete first line of results as it contains rra names
  results.delete_at(0)

  results.each do |line|
    r << [line[0], line[index]] if line[index] and line[index].class == Float and !line[index].nan?
  end
  rrd = nil
  r
end