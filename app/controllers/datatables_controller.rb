class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.all
  end

  def new
    @datatable = Datatable.new
  end

  # def upload
  #   @datatable = params[:uploaded_file].read
  #   p 'content'
  #   p @datatable
  # end

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    sheet = spreadsheet.sheet(0)
    # p sheet.size
    hash_array = []
    sheet.each(key: 'key', data: 'value') do |hash|
      hash_array.push(hash.inspect)
    end
    hash_array[1..-1].each do |e|
      key = eval(e)[:key]
      value = eval(e)[:data]
      @datatable = Datatable.new({key: key, value: value, graph_id: params[:graph_id]})
      p @datatable.valid?
      @datatable.save
    end
    redirect_to root_url, notice: 'Products imported.'
  end

  # def create
  #   @datatable = params[:uploaded_file]
  #   p 'content'
  #   p @datatable
  #   raise
  #   @datatable = Datatable.new(datable_params)
  #   if @datatable.save
  #     redirect_to datatables_path
  #   end
  # end

  private

  def datable_params
    params.require(:datatable).permit(:data, :key)
  end
end
