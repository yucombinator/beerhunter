class SiteController < ActionController::Base
  def index
    @result = HTTParty.get "http://ontariobeerapi.ca:80/stores/4164/products/"
    @results = []
    @result.each do |post|
      p post['size']

      matched = post['size'].scan(/([0-9]+)/)
      p matched

      @qty = matched[0][0]
      @volume = matched[1][0]

      p @qty
      p @volume

      @price = post['price']
      @abv = post['abv'].to_f

      p @abv

      value_score = @qty.to_f * @volume.to_f * @abv/ @price.to_f
      @results.push({:name => post['name'], :size => post['size'], :abv => @abv, :abv => @abv, :volume => @volume, :price => @price, :value_score => value_score})
      @results_sorted = @results.sort_by {|obj| obj[:value_score]}.reverse!
    end
  end
end