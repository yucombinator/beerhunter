class SiteController < ApplicationController
  helper :all
  def index

  end
  def listing
    if params[:limit] == nil
      @limit = 14
    else
      @limit = params[:limit].to_i
    end

    if params[:store_id] == nil
      @store = 4164
    else
      @store = params[:store_id].to_i
    end

    @result = HTTParty.get "http://ontariobeerapi.ca:80/stores/" + @store.to_s + "/products/"
    @results = []
    @result.each do |post|

      matched = post['size'].scan(/([0-9]+)/)

      @qty = matched[0][0]
      @volume = matched[1][0]

      @price = post['price']
      @on_sale = post['on_sale']
      @abv = post['abv'].to_f

      value_score = @qty.to_f * @volume.to_f * @abv/ @price.to_f
      @results.push({:name => post['name'], :size => post['size'], :abv => @abv, :volume => @volume, :price => @price, :value_score => value_score, :on_sale => @on_sale})
    end

    if @limit > @results.length - 1
      @limit = @results.length - 1
    end

    @results_sorted = @results.sort_by {|obj| obj[:value_score]}.reverse![0..@limit]
  end

  def get_store_listing
    @res = HTTParty.get "http://ontariobeerapi.ca:80/stores/"
    render json: @res
  end
end