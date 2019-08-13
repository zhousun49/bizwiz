class GraphsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @graph = Graph.new
    @graph.save
    redirect_to new_graph_datatable_path(@graph)
  end

  def show
    @graph = Graph.find(params[:id])
    @qr = RQRCode::QRCode.new("http://bizwiz.herokuapp.com/graphs/#{params[:id]}")
    @datatables = @graph.datatables
    @data_arrays = []
    @pie_array = []
    total_value = 0
    @datatables.each { |e| total_value += e.value }
    @data_series = @datatables.group_by { |data| data[:series] }
    @data_series.each do |k, v|
      arr = Array.new
      v.each do |data|
        m_arr = Array.new
        m_arr << data.column
        m_arr << data.value
        arr << m_arr
      end
      @data_arrays << arr
    end

    @series_name = []
    @data_series.each do |k, v|
      @series_name << k
    end

    @options = []
    @series_name.each_with_index do |n, i|
      @options << {name: n, data: @data_arrays[i]}
    end

    @data_series.each do |k, v|
      v.each do |data|
        m_arr =Array.new
        m_arr << k
        m_arr << (data.value * 100 / total_value).round(1)
        @pie_array << m_arr
      end
    end
  end

  def update
    @graph = Graph.find(params[:id])
    if @graph.update(graph_params)
      redirect_to graph_path(@graph.id)
    else
      render :new
    end
  end

  def destroy
    @graph = Graph.find(params[:id])
    @graph.destroy
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:graph).permit(:category, :name, :x_axis_title, :y_axis_title)
  end
end
