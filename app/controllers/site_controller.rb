class SiteController < ApplicationController
  helper :all
  def index

  end
  def listing
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
      @on_sale = post['on_sale']
      @abv = post['abv'].to_f

      p @abv

      value_score = @qty.to_f * @volume.to_f * @abv/ @price.to_f
      @results.push({:name => post['name'], :size => post['size'], :abv => @abv, :volume => @volume, :price => @price, :value_score => value_score})
      @results_sorted = @results.sort_by {|obj| obj[:value_score]}.reverse![0..14]
    end
  end

  def get_store_listing
    @res = HTTParty.get "http://ontariobeerapi.ca:80/stores/"
    render json: @res
  end
end