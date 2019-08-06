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
    sheet.each_row_streaming { |r| row.push(r) }
    if row[0].last.value.class == String
      row[1..-1].each { |e| key.push(e[0].value)}
      row[1..-1].each_with_index do |e, i|
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: key[i], value: v.value, graph_id: params[:graph_id]})
        end
      end
    else
      row[0..-1].each { |e| key.push(e[0].value)}
      p key
      row[0..-1].each_with_index do |e, i|
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: key[i], value: v.value, graph_id: params[:graph_id]})
        end
      end
end

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
