class CollectionsController < ApplicationController
  def index
  end

  def create
    @collection = Collection.new
    @collection.slug = SecureRandom.hex(10)
    @collection.save
    redirect_to new_collection_datatable_path(@collection.slug)
  end

  def show
    @collection = Collection.find_by(slug: params[:slug])
    @qr = RQRCode::QRCode.new("http://bizwiz.herokuapp.com/collections/#{params[:slug]}")
    @graphs = @collection.graphs
    @canvas_data = []

    @graphs.each do |graph|
      arr = graph.datatables.group_by { |data| data[:graph_id]}
      @canvas_data << arr
    end

    @multi_series_options = []
    @pie_options = []
    @geo_options = []
    @canvas_data.each do |graph|
      graph.each_with_index do |(graph_id, datatables), i|
        total_value = 0
        datatables.each { |e| total_value += e.value }


        multi_series_graph_import = {}
        pie_graph_import = {}
        geo_graph_import = {}

        multi_series_graph_import[:graph_id] = graph_id
        pie_graph_import[:graph_id] = graph_id
        geo_graph_import[:graph_id] = graph_id

        @multi_series_options << multi_series_graph_import
        @pie_options << pie_graph_import
        @geo_options << geo_graph_import

        multi_series_graph_import[:options] = []
        pie_graph_import[:options] = []
        geo_graph_import[:options] = []


        @data_series = datatables.group_by { |data| data[:series] }

        @data_series.keys.each do |key|
          multi_series_graph_import[:options] << { name: key }
        end

        @data_series.each_with_index do |(k, v), ii|
          arr = []
          v.each do |data|
            m_arr = []
            m_arr << data.column
            m_arr << data.value
            arr << m_arr
          end
          multi_series_graph_import[:options][ii][:data] = arr
        end


        @data_series.each_with_index do |(k, v), iii|
          arr = []
          v.each do |data|
            arr << k
            arr << (data.value * 100 / total_value).round(1)
          end
          pie_graph_import[:options][iii] = arr
        end

        @data_series.each_with_index do |(k, v), iiii|
          arr = []
          v.each do |data|
            arr << k
            arr << data.value
          end
          geo_graph_import[:options][iiii] = arr
        end
      end
    end
  end

end

