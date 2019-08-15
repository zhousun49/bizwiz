class DatatablesController < ApplicationController
  def index
    graph = Graph.find_by(slug: params[:graph_slug])
    @datatables = Datatable.where(graph_id: graph.id)
    @graph = @datatables.first.graph
    @datatable = Datatable.new
    # @datatable.graph_id = params[:graph_id]
    total_value = 0
    @datatables.each { |e| total_value += e.value }
    @data_arrays = []
    @pie_array = []
    @geo_array = []

    # In order for chartkick to recognize columns, data needs to be an array
    # of [Col, Val] array pairs

    @data_series = @datatables.group_by { |data| data[:series] }

    @data_series.each do |_k, v|
      v.sort!
      arr = []
      v.each do |data|
        m_arr = []
        m_arr << data.column
        m_arr << data.value
        arr << m_arr
      end
      @data_arrays << arr
    end

    # This builds an array of series names, to be used when building the options
    # array below.

    @series_name = []
    @data_series.each do |k, _v|
      @series_name << k
    end

    # The options array is passed to the line graph and area graph. It counts how
    # many series there are, and builds the options for each series. We can expand
    # on this to add customization (colors etc.)

    @options = []
    @series_name.each_with_index do |n, i|
      @options << { name: n, data: @data_arrays[i] }
    end

    # this makes an array specifically for a pie chart, automatically calculating
    # percentage

    @data_series.each do |k, v|
        v.each do |data|
        arr = []
        arr << k
        arr << (data.value * 100 / total_value).round(1)
        @pie_array << arr
      end
    end

    # this makes an array specifically for a geo_chart

    @data_series.each do |k, v|
      v.each do |data|
        arr = []
        arr << k
        arr << data.value
        @geo_array << arr
      end
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
      @graph = Graph.create({category: "bar_chart", collection_id: c.id, slug: graph_slug})
      s = page.text.split("\n")
      s.each do |e|
        e = e.split
        e[1..-1].each do |v|
          @datatable = Datatable.create({
            series: e[0],
            value: v.to_f,
            graph_id: @graph.id
          }) if (e[0].empty? == false) && (v.to_f != 0)
        end
      end
    end
  end

  def docx_read
    doc = Docx::Document.open(@datatable.path)

    doc.tables.each do |table|
      graph_slug = SecureRandom.hex(10)
      c = Collection.find_by(slug: params[:collection_slug])
      @graph = Graph.create({category: "bar_chart", collection_id: c.id, slug: graph_slug})
      @series = []
      @columns = []
      @dataset = []
      table.rows.each do |row|
        arr = []
        row.cells.each do |e|
          arr << e.text if e.text != ""
        end
          @dataset << arr
      end
      @dataset[0].each { |e| @columns.push(e) }
      @dataset[1..-1].each { |e| @series.push(e[0]) }
    end

    @dataset[1..-1].each_with_index do |d, i|
      d[1..-1].each_with_index do |v, ii|
        @datatable = Datatable.create({ series: @series[i], column: @columns[ii], value: v.to_f, graph_id: @graph.id }) if (@dataset[0].empty? == false) && (v.to_f != 0)
      end
    end
  end

  def xlsx_read
    spreadsheet = Roo::Excelx.new(@datatable.path)
    spreadsheet.sheets.each do |name|
      # Create a new graph for each Excel sheet
      graph_slug = SecureRandom.hex(10)
      c = Collection.find_by(slug: params[:collection_slug])
      @graph = Graph.create({name: name, category: "bar_chart", collection_id: c.id, slug: graph_slug})

      # Added series and columns arrays that are passed to the datatable object
      # and then used when building arrays
      @dataset = []
      @series = []
      @columns = []
      spreadsheet.sheet(name).each_row_streaming { |r| @dataset.push(r) }
      @dataset[0].each { |e| @columns.push(e.value) }
      @dataset[1..-1].each { |e| @series.push(e[0].value) }

      # If the last cell of the first row in the Excel is a string, begin collecting the data from the next row instead.
      @dataset[1..-1].each_with_index do |e, i|
        e[1..-1].each_with_index do |v, ii|
          @datatable = Datatable.create({
            series: @series[i],
            column: @columns[ii],
            value: v.value.to_i,
            graph_id: @graph.id
          }) if (v.value.to_i != 0) && (e[0].nil? == false)
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
    params.require(:datatable).permit(:value, :column, :series, :graph_id)
  end
end
