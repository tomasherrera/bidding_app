require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe 'GET /snapshot.json' do

    let!(:user_1) do
      User.create(budget: 1000)
    end
    let!(:item_1) do
      Item.create(user_id: user_1.id, item_name: "iPhone", start_price: 600)
    end

    it "shows current status of auctions and users" do
      get :index, format: :json
      expect(json["result"]).to eq("success")
      expect(json["data"].keys).to eq(["auctions", "users"])
      expect(json["data"]["users"]).to include({"id"=>user_1.id, "budget"=>1000, "blockedBudget"=>0, "ownedItemIds"=>[item_1.id]})
      expect(json["data"]["auctions"]).to include({"id"=>item_1.auction.id, "userId"=>user_1.id, "isActive"=>true, "bestBidderId"=>nil, "currentPrice"=>600})
    end
  end

  describe 'PUT /bid.json' do

    let!(:user_1) do
      User.create(budget: 1000)
    end

    let!(:user_2) do
      User.create(budget: 2000)
    end

    let!(:user_3) do
      User.create(budget: 3000)
    end

    let!(:item_1) do
      Item.create(user_id: user_1.id, item_name: "iPhone", start_price: 600)
    end

    it "bids for an item" do
      put :bid, format: :json, userId: user_2.id, itemId: item_1.id, amount: 601
      expect(json["result"]).to eq("success")
      expect(item_1.auction.current_price).to eq(601)
      expect(item_1.auction.best_bidder_id).to eq(user_2.id)
      expect(user_2.reload.budget).to eq(1399)
      expect(user_2.reload.blocked_budget).to eq(601)
    end

    it "returns errors when amount is lower than current_price or is higher than user's budget" do
      item_1.auction.current_price = 3000
      item_1.auction.save!
      put :bid, format: :json, userId: user_2.id, itemId: item_1.id, amount: 2500
      expect(json["result"]).to eq("error")
      expect(item_1.auction.current_price).to eq(3000)
      expect(item_1.auction.best_bidder_id).to eq(nil)
      expect(json["errors"]).to include("invalid amount", "insufficient funds")
    end

    it "returns funds when new higher bid is put" do
      item_1.auction.current_price = 601
      item_1.auction.best_bidder_id = user_2.id
      item_1.auction.save!
      user_2.budget = 1399
      user_2.blocked_budget = 601
      user_2.save!      
      put :bid, format: :json, userId: user_3.id, itemId: item_1.id, amount: 3000
      expect(json["result"]).to eq("success")
      expect(user_2.reload.budget).to eq(2000)
      expect(user_2.reload.blocked_budget).to eq(0)
    end

    it "returns errors when auction is closed" do
      item_1.auction.is_active = false
      item_1.auction.save!
      put :bid, format: :json, userId: user_2.id, itemId: item_1.id, amount: 601
      expect(json["result"]).to eq("error")
      expect(json["errors"]).to include("auction closed")
    end
  end

  describe 'PUT /finish.json' do

    let!(:user_1) do
      User.create(budget: 1000)
    end

    let!(:user_2) do
      User.create(budget: 2000)
    end

    let!(:item_1) do
      Item.create(user_id: user_1.id, item_name: "iPhone", start_price: 600)
    end

    it "finishes an auction" do
      item_1.auction.current_price = 3000
      item_1.auction.best_bidder_id = 2
      item_1.auction.save!

      put :finish, format: :json, itemId: item_1.id
      expect(json["result"]).to eq("success")
      expect(json["data"]["winnerId"]).to eq(2)
      expect(json["data"]["price"]).to eq(3000)
    end
  end
end
