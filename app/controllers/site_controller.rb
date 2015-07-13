class SiteController < ActionController::Base
  def index
    @result = HTTParty.get "http://ontariobeerapi.ca:80/stores/4164/products/"
    @results = []
    @result.each do |post|
      p post['size']

      matched = post['size'].split(' ') #.scan(/([0-9])\w+/i)
      matched = matched[0].split(' ') #.scan(/([0-9])\w+/i)

      @qty = matched[0]
      @volume = matched[3]
      @price = post['price']
      @abv = post['abv'].to_f

      p @abv

      value_score = @qty.to_f * @volume.to_f * @abv/ @price.to_f
      @results.push({:name => post['name'], :size => post['size'], :abv => @abv, :abv => @abv, :volume => @volume, :price => @price, :value_score => value_score})
      @results_sorted = @results.sort_by {|obj| obj[:value_score]}.reverse!
    end
  end
end