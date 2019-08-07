require 'roo'

xlsx = Roo::Excelx.new("/mnt/c/Users/Zhou Sun/Desktop/text.xlsx")

row = []
key = []

sheet = xlsx.sheet(0)
sheet.each_row_streaming do |r|
  row.push(r)
end
p row[0].last.value.class

row[0..-1].each { |e| key.push(e[0].value)}
p key
row[0..-1].each_with_index do |e, i|
  # p e
  e[1..-1].each do |v|
    p '------------------------------'
    p v.value
    p key[i]
    p 'saved'
  end
end
