class StationsController < ApplicationController
  def index
    @stations = Station.pluck(:name, :id)
    @results = []
    @n = params[:n] || 0

    @from = params[:from] || Station.where(name: 'East Ham').first.id

    if @n.present? && @n.to_i > 0
      # to_ignore = []
      # ids = [@from]
      # @n.to_i.times do
      #   to_ignore |= ids
      #   ids = StationLink.where(from_id: ids).where.not(to_id: to_ignore).pluck(:to_id)
      #   ids = ids - to_ignore
      # end
      # @results = Station.where(id: ids).order(:name).pluck(:name)

      select_opts = []
      skope = Station.where(id: @from)
      
      (1..@n.to_i).each do |i|
        prev = i == 1 ? 'id' : "s#{i.to_i - 1}.to_id"
        select_opts << prev if i != @n
        skope =  skope.joins("INNER JOIN station_links AS s#{i} ON s#{i}.from_id = #{prev}")
      end

      res = skope.select("DISTINCT #{select_opts.join(' || "," || ')} AS ignore, s#{@n}.to_id AS last").all
      ignore = []
      ids = []
      res.map do |r|
        ids << r.last
        ignore |= r.ignore.split(',').map(&:to_i)
      end
      @results = Station.where(id: ids - ignore).order(:name).pluck(:name)
    end
  end
end
