class Item < ActiveRecord::Base
  belongs_to :user
  has_one :auction, dependent: :destroy
  validates :start_price, presence: true, numericality: { only_integer: true }
  validates_presence_of :item_name, :user
  after_create :start_auction

  def start_auction
    Auction.create!(item_id: id, user_id: user_id, current_price: start_price, is_active: true, best_bidder_id: nil)
  end
end
