class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all
    @users = User.all
    respond_to do |format|
      format.json
    end
  end

  def bid
    @auction = Auction.find_by_item_id(params[:itemId])
    @errors = @auction.bid(params[:userId], params[:itemId], params[:amount])
    respond_to do |format|
      format.json
    end
  end

  def finish
    @auction = Auction.find_by_item_id(params[:itemId])
    @auction.finish
    respond_to do |format|
      format.json
    end
  end
end
