class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.all
  end

  def new
    @datatable = Datatable.new
  end

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    sheet = spreadsheet.sheet(0)
    row = []
    key = []
    value = []
    sheet.each_row_streaming do |r|
      row.push(r)
    end
    row[1..-1].each do |e|
      key.push(e[0])
      value.push(e[1])
    end
    key_string = key.map(&:value).join(", ")
    value_string = value.map(&:value).join(", ")
    @datatable = Datatable.new(
      key: key_string,
      value: value_string,
      graph_id: params[:graph_id]
    )
    @datatable.save
    redirect_to graph_datatables_path(params[:graph_id]), notice: 'Products imported.'
  end

  def destroy
    @datatables = Datatable.all
    @graph = @datatables.last.graph
    @datatables.destroy_all
    @graph.destroy
    redirect_to root_path
  end

  private

  def datable_params
    params.require(:datatable).permit(:data, :key)
  end
end
