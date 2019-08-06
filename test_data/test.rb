require 'roo'

xlsx = Roo::Spreadsheet.open('/mnt/c/Users/Zhou Sun/Desktop/text.xlsx')
# p xlsx
xlsx = Roo::Excelx.new("/mnt/c/Users/Zhou Sun/Desktop/text.xlsx")

# xlsx.sheet(0).row.each do |s|
#   p s
# end
sheet = xlsx.sheet(0)
# p sheet.size
p sheet.row(1)

sheet.each(id: 'name', name: 'price') do |hash|
  puts hash.inspect
  # => { id: 1, name: 'John Smith' }
end
