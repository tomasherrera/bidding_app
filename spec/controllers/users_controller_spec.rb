require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  render_views

  let(:json) { JSON.parse(response.body) }

  describe 'POST /add_user.json' do

    let!(:user_1) do
      User.create(id: 1,budget: 1000)
    end

    it "creates a new user and returns success" do
      post :create, format: :json, userId: 2, budget: 2000
      expect(User.last.budget).to eq(2000)
      expect(json["result"]).to eq("success")
    end

    it "does not create a new user if id is already taken" do
      post :create, format: :json, userId: 1, budget: 2000
      expect(json["errors"]).to include("Id has already been taken")
    end

    it "does not create a new user if budget is not a number" do
      post :create, format: :json, userId: 2, budget: "dos_mil"
      expect(json["errors"]).to include("Budget is not a number")
    end

    it "does not create a new user if budget is missing" do
      post :create, format: :json, userId: 2, budget: nil
      expect(json["errors"]).to include("Budget can't be blank")
    end
  end

end
