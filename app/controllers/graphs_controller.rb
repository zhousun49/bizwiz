class GraphsController < ApplicationController
  skip_before_action :verify_authenticity_token

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

  def update
    @graph = Graph.find(params[:id])
    @graph.update(graph_params)

    # please help me to refactor with the following lines:

    # if @graph.update
    #   redirect_to graph_datatables_path(graph_id: graph_id)
    # else
    #   render :new
    # end
  end

  def destroy
    @graph = Graph.find(params[:id])
    @graph.destroy
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:graph).permit(:category)
  end
end
