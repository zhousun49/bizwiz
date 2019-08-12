class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.where(graph_id: params[:graph_id])
    @datatable = Datatable.new
    @graph = @datatables.first.graph
    @data_array = []
    @datatables.each do |data|
      @temp_array = []
      @temp_array << data.key
      @temp_array << data.value
      @data_array << @temp_array
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

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    spreadsheet.sheets.each_with_index do |s, index|
      sheet = spreadsheet.sheet(index)
      @row = []
      sheet.each_row_streaming { |r| @row.push(r) }
      if @row[0].last.value.class == String
        display(1, index)
      else
        display(0, index)
      end
      redirect_to graph_datatable_charts_path(params[:graph_id])
      # redirect_to graph_datatables_path(params[:graph_id])
    end
  end

  def display(integer, index)
    key = []
    @row[integer..-1].each { |e| key.push(e[0].value)}
    @row[integer..-1].each_with_index do |e, i|
      e[1..-1].each do |v|
        @datatable = Datatable.create({key: key[i], value: v.value, graph_id: params[:graph_id], sheet_id: index}) if (v.value.nil? == false) && (key[i].nil? == false)
      end
    end
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
