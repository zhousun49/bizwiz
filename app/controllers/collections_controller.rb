class CollectionsController < ApplicationController
  def index
  end

  def create
    @collection = Collection.new
    @collection.save
    redirect_to new_collection_datatable_path(@collection)
  end

  def show
    @collection = Collection.find(params[:id])
    @graphs = @collection.graphs
    @canvas_data = []
    @graphs.each_with_index do |graph, i|
      keys = []
      values = []
      graph.datatables.each do |d|
        keys << d.key
        values << d.value
      end
      @canvas_data << Hash[keys.zip(values)]
    end
  end
end
