require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe 'POST /add_item.json' do

    let!(:user_1) do
      User.create(id: 1,budget: 1000)
    end

    it "creates a new item and returns success and item_id" do
      post :create, format: :json, userId: 1, itemName: "iPhone", startPrice: 600
      expect(Item.last.item_name).to eq("iPhone")
      expect(json["result"]).to eq("success")
      expect(json["data"]).to eq(Item.last.id)
    end

    it "does not create a new item if there is a param missing" do
      post :create, format: :json, userId: 1
      expect(json["errors"]).to include("Start price can't be blank", "Item name can't be blank")
    end

    it "does not create a new item if start_price is not a number" do
      post :create, format: :json, userId: 1, itemName: "iPhone", start_price: "precio"
      expect(json["errors"]).to include("Start price is not a number")
    end
  end

end
