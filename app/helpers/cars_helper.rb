module CarsHelper
  def sortable(title, column)
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }
  end
end
