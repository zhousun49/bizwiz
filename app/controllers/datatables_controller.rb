class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.where(graph_id: params[:graph_id])
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

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    sheet = spreadsheet.sheet(0)
    row = []
    key = []
    sheet.each_row_streaming do |r|
      row.push(r)
    end
    row[1..-1].each { |e| key.push(e[0])}
    row[1..-1].each_with_index do |e, i|
      e[1..-1].each do |v|
        p '------------------------------'
        p v.value
        p key[i].value
        @datatable = Datatable.new({key: key[i].value, value: v.value, graph_id: params[:graph_id]})
        p @datatable.valid?
        @datatable.save
        p 'saved'
      end
    end
    redirect_to graph_datatables_path(params[:graph_id]), notice: 'Products imported.'
  end

  def destroy
    @datatables = Datatable.where(graph_id: params[:graph_id])
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
