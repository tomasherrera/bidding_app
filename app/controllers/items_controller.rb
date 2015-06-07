class ItemsController < ApplicationController
  def create
    @item = Item.new(user_id: params[:userId], item_name: params[:itemName], start_price: params[:startPrice])
    if @item.save
      respond_to do |format|
        format.json
      end
    else
      render :json => {:errors => @item.errors.full_messages}
    end
  end
end