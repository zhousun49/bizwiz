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

  def import
    @datatable = params[:file]
    xlsx_read if params[:file].original_filename.match(/.xlsx/)
    docx_read if params[:file].original_filename.match(/.docx/)
    pdf_read if params[:file].original_filename.match(/.pdf/)
    redirect_to graph_datatables_path(params[:graph_id])
  end

  def pdf_read
    reader = PDF::Reader.new("/mnt/c/Users/Zhou Sun/Desktop/text.pdf")
    reader.pages.each do |page|
      s = page.text.split("\n")
      s.each do |e|
        e = e.split
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: e[0], value: v, graph_id: params[:graph_id]}) if (e[0].empty? == false) && (v.to_f != 0)
        end
      end
    end
  end

  def xlsx_read
    spreadsheet = Roo::Excelx.new(@datatable.path)
    sheet = spreadsheet.sheet(0)
    @row = []
    sheet.each_row_streaming { |r| @row.push(r) }
    if @row[0].last.value.class == String
      display(1)
    else
      display(0)
    end
  end

  def docx_read
    doc = Docx::Document.open(@datatable.path)
    # first_table = doc.tables[0]
    doc.tables.each do |table|
      table.rows.each do |row|
        data = []
        row.cells.each { |e| data << e.text }
        data[1..-1].each do |d|
          @datatable = Datatable.create({key: data[0], value: d.to_f, graph_id: params[:graph_id]}) if (data[0].empty? == false) && (d.to_f != 0)
        end
      end
    end
  end

  def display(integer)
    key = []
    @row[integer..-1].each { |e| key.push(e[0].value)}
    @row[integer..-1].each_with_index do |e, i|
      e[1..-1].each do |v|
        @datatable = Datatable.create({key: key[i], value: v.value, graph_id: params[:graph_id]}) if (v.value.nil? == false) && (key[i].nil? == false)
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
