class GraphsController < ApplicationController
  def create
    @graph = Graph.new
    @graph.save
    redirect_to new_graph_datatable_path(@graph)
  end

  def show
    @graph = Graph.find(params[:id])
    @graph_data = @graph.datatables[0]
    keys = @graph_data.key.split(", ")
    values = @graph_data.value.split(", ").map(&:to_i)
    @data_hash = Hash[keys.zip(values)]
  end
end
