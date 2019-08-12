class ChartsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    p "blah"
    @chart = Chart.new
  end

  def create
    @chart = Chart.new
    @chart.save
    redirect_to new_graph_chart_datatable_path(@chart)
  end

  def show
    @chart = Chart.find(params[:id])
    # update QR link
    @qr = RQRCode::QRCode.new("http://bizwiz.herokuapp.com/graphs/#{params[:id]}")
    @datatables = @chart.graph.datatables
    @data_array = []
    @datatables.each do |data|
      @temp_array = []
      @temp_array << data.key
      @temp_array << data.value
      @data_array << @temp_array
    end
  end

  def update
    @chart = Chart.find(params[:id])
    if @chart.update(graph_params)
      redirect_to graph_path(@chart.id)
    else
      render :new
    end
  end

  def destroy
    @chart = Chart.find(params[:id])
    @chart.destroy
    redirect_to root_path
  end

  private

  def graph_params
    params.require(:graph).permit(:category, :name, :x_axis_title, :y_axis_title)
  end

  def chart_params
    params.require(:chart).permit(:category, :name, :x_axis_title, :y_axis_title)
  end
end
