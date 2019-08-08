class GraphsController < ApplicationController
  def create
    @graph = Graph.new
    @graph.save
    redirect_to new_graph_datatable_path(@graph)
  end

  def show
    @graph = Graph.find(params[:id])
    @datatables = @graph.datatables
    @data_array = []
    @datatables.each do |data|
      @temp_array = []
      @temp_array << data.key
      @temp_array << data.value
      @data_array << @temp_array
    end
  end

  def destroy
    @graph = Graph.find(params[:id])
    @graph.destroy
    redirect_to root_path
  end
end
