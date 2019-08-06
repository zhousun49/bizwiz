class GraphsController < ApplicationController
  def new
    @graph = Graph.new
  end

  def create
    @graph = Graph.new
    @graph.save
    redirect_to new_graph_datatable_path(@graph)
  end
end
