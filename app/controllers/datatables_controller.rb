class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.where(graph_id: params[:graph_id])
    @datatable = Datatable.new
    @graph = @datatables.first.graph
    total_value = 0
    @datatables.each { |e| total_value += e.value }
    @data_array = []
    @pie_array = []
    @datatables.each do |data|
      # @temp_array = []
      # @temp_array << data.key
      # @temp_array << data.value
      # @data_array << @temp_array
      @pie_array << [data.key, (data.value * 100 / total_value).round(1)]
      @data_array << [data.key, data.value]
    end
  end

  def new
    @datatable = Datatable.new
  end

  def create
    @datatable = Datatable.new(datable_params)
    @datatable.graph_id = params[:graph_id]
    if @datatable.update(datable_params)
      redirect_to graph_datatables_path
    else
      render :new
    end
  end

# @row is an array of Cell objects, each which has a
# cell value, a style, a cell type (numeric or formula) a coordinate [row, column], and a value
# which is the same as cell-value. We want to group arrays based on row coordinate.

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    sheet = spreadsheet.sheet(0)
    @dataset = []
    sheet.each_row_streaming { |r| @dataset.push(r) }
    if @dataset[0].last.value.class == String
      display(1)
    else
      display(0)
    end
    redirect_to graph_datatables_path(params[:graph_id])
  end

  def display(integer)
    @series = []
    @columns = []
    @dataset[0].each { |e| @columns.push(e.value) }
    @dataset[integer..-1].each { |e| @series.push(e[0].value) }
    @dataset[integer..-1].each_with_index do |e, i|
      e[1..-1].each_with_index do |v, ii|
        @datatable = Datatable.create({series: @series[i], column: @columns[ii], value: v.value, graph_id: params[:graph_id]}) if (v.value.nil? == false) && (@series[i].nil? == false)
      end
    end
    raise
  end

  def edit
    @datatable = Datatable.find(params[:id])
  end

  def update
    @datatable = Datatable.find(params[:id])
    @graph = @datatable.graph
    if @datatable.update(datable_params)
      redirect_to graph_datatables_path
    else
      render :edit
    end
  end

  def destroy
    @datatable = Datatable.find(params[:id])
    graph_id = @datatable.graph_id
    @datatable.destroy
    redirect_to graph_datatables_path(graph_id: graph_id)
  end

  private

  def datable_params
    params.require(:datatable).permit(:value, :key)
  end
end
