[
  {id: 1, name: "Lunes"},
  {id: 2, name: "Martes"},
  {id: 3, name: "Miércoles"},
  {id: 4, name: "Jueves"},
  {id: 5, name: "Viernes"},
  {id: 6, name: "Sábado"},
  {id: 7, name: "Domingo"}
].each do |attributes|
  day = Day.find_by(id: attributes[:id])
  if day.nil?
    day = Day.new
  end
  day.attributes = attributes
  day.save!
end