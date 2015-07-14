module ApplicationHelper
  def abv_color(abv)
    if abv < 6.0
      'green'
    elsif abv < 8.0
      'yellow'
    else
      'red'
    end
  end
end
