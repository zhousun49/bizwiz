class DatatablesController < ApplicationController
  def index
    graph = Graph.find_by(slug: params[:graph_slug])
    @datatables = Datatable.where(graph_id: graph.id)
    @graph = @datatables.first.graph
    @datatable = Datatable.new
    # @datatable.graph_id = params[:graph_id]
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
    @datatable = Datatable.new
    graph = Graph.find_by(slug: params[:graph_slug])
    @datatable.graph_id = graph.id
    if @datatable.update(datatable_params)
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
    redirect_to collection_path(params[:collection_slug])
  end

  def pdf_read
    reader = PDF::Reader.new(@datatable.path)
    reader.pages.each do |page|
      graph_slug = SecureRandom.hex(10)
      c = Collection.find_by(slug: params[:collection_slug])
      @graph = Graph.create({collection_id: c.id, slug: graph_slug})
      s = page.text.split("\n")
      s.each do |e|
        e = e.split
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: e[0], value: v.to_f, graph_id: @graph.id}) if (e[0].empty? == false) && (v.to_f != 0)
        end
      end
    end
  end

  def docx_read
    doc = Docx::Document.open(@datatable.path)
    doc.tables.each do |table|
      graph_slug = SecureRandom.hex(10)
      c = Collection.find_by(slug: params[:collection_slug])
      @graph = Graph.create({collection_id: c.id, slug: graph_slug})
      table.rows.each do |row|
        data = []
        row.cells.each { |e| data << e.text }
        data[1..-1].each do |d|
          @datatable = Datatable.create({ key: data[0], value: d.to_f, graph_id: @graph.id }) if (data[0].empty? == false) && (d.to_f != 0)
        end
      end
    end
  end

  def xlsx_read
    spreadsheet = Roo::Excelx.new(@datatable.path)
    spreadsheet.sheets.each do |name|
      # Create a new graph for each Excel sheet
      graph_slug = SecureRandom.hex(10)
      c = Collection.find_by(slug: params[:collection_slug])
      @graph = Graph.create({name: name, collection_id: c.id, slug: graph_slug})
      # sheet = spreadsheet.sheet(name)
      @row = []
      spreadsheet.sheet(name).each_row_streaming { |r| @row.push(r) }
      # If the last cell of the first row in the Excel is a string, begin collecting the data from the next row instead.
      @row[0..-1].each do |e|
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: e[0], value: v.value.to_i, graph_id: @graph.id}) if (v.value.to_i != 0) && (e[0].nil? == false)
        end
      end
    end
  end

  def edit
    @datatable = Datatable.find(params[:id])
  end

  def update
    @datatable = Datatable.find(params[:id])
    @graph = @datatable.graph
    if @datatable.update(datatable_params)
      redirect_to graph_datatables_path(@graph.slug)
    else
      render :edit
    end
  end

  def destroy
    @datatable = Datatable.find(params[:id])
    @graph = @datatable.graph
    @datatable.destroy
    redirect_to graph_datatables_path(@graph.slug)
  end

  private

  def datatable_params
    params.require(:datatable).permit(:value, :key, :graph_id)
  end
end
