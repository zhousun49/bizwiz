require 'roo'

xlsx = Roo::Spreadsheet.open('/mnt/c/Users/Zhou Sun/Desktop/Lab.xlsx')
xlsx = Roo::Excelx.new("/mnt/c/Users/Zhou Sun/Desktop/Lab.xlsx")

p xlsx.sheet(0).row(3)
