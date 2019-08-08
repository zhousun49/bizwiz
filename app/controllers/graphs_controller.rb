class GraphsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @graph = Graph.new
    @graph.save
    redirect_to new_graph_datatable_path(@graph)
  end

  def show
    @graph = Graph.find(params[:id])
    @qr = RQRCode::QRCode.new("bizwiz.herokuapp.com/graphs/#{params[:id]}")
    @datatables = @graph.datatables
    @data_array = []
    @datatables.each do |data|
      @temp_array = []
      @temp_array << data.key
      @temp_array << data.value
      @data_array << @temp_array
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
