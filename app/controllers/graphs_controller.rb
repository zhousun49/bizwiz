class GraphsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @graph = Graph.new
    redirect_to new_graph_datatable_path(@graph.slug)
  end

  def show
    @graph = Graph.find_by(slug: params[:slug])
    if @graph.nil?
      render "graphs/empty"
    elsif Time.now > @graph.created_at + 15.minutes
      @graph.destroy
      render "graphs/empty"
    else
      @qr = RQRCode::QRCode.new("http://bizwiz.herokuapp.com/graphs/#{params[:slug]}")
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
  end

  def update
    @graph = Graph.find_by(slug: params[:slug])
    if @graph.update(graph_params)
      redirect_to graph_path(@graph.slug)
    else
      render :new
    end
  end

  def destroy
    @graph = Graph.find_by(slug: params[:slug])
    @graph.destroy
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:graph).permit(:category, :name, :x_axis_title, :y_axis_title, :slug)
  end
end
