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
    @graphs = @collection.graphs
  end
end
