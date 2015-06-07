class Item < ActiveRecord::Base
  belongs_to :user
  has_one :auction
  validates :start_price, presence: true, numericality: { only_integer: true }
  validates_presence_of :item_name, :user_id
  after_create :start_auction

  def start_auction
    user = User.find(user_id)
    Auction.create!(item_id: id, user_id: user_id, current_price: start_price, is_active: true, best_bidder_id: nil)
    user.owned_item_ids << id
    user.save!
  end
end
