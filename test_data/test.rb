require 'roo'

# xlsx = Roo::Spreadsheet.open('/mnt/c/Users/Zhou Sun/Desktop/text.xlsx')
# p xlsx
xlsx = Roo::Excelx.new("/mnt/c/Users/Zhou Sun/Desktop/text.xlsx")

# # xlsx.sheet(0).row.each do |s|
# #   p s
# # end
# sheet = xlsx.sheet(0)
# # p sheet.size
# p sheet.row(1)

# # sheet.each(key: 'key', value: 'price') do |hash|
# #   puts hash.inspect
# #   # => { id: 1, name: 'John Smith' }
# # end
row = []
key = []

sheet = xlsx.sheet(0)
sheet.each_row_streaming do |r|
  row.push(r)
  # key.push(r(0)) # Array of Excelx::Cell objects
end
# p row

row[1..-1].each { |e| key.push(e[0])}
p key
row[1..-1].each_with_index do |e, i|
  e[1..-1].each do |v|
    p '------------------------------'
    p v.value
    p key[i].value
    p 'saved'
  end
end

# p key
# p 'key'
# p row[1][0].value
# p 'value'
# p row[1][1].value
# first_row = row[1]
# first_row.each do |e|
#   key = 1
# end
