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
    @data_array = []
    @pie_array = []
    total_value = 0
    @datatables.each { |e| total_value += e.value }
    @datatables.each do |data|
      @pie_array << [data.key, (data.value * 100 / total_value).round(1)]
      @data_array << [data.key, data.value]
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
