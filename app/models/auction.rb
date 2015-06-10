class Auction < ActiveRecord::Base
  belongs_to :item,  dependent: :destroy
  belongs_to :user
  belongs_to :best_bidder, class_name: 'User', foreign_key: 'best_bidder_id'

  validates :item_id, :user_id, :current_price, presence: true, numericality: { only_integer: true }

  def bid(user_id, amount)
    amount = amount.to_i
    bidder = User.find(user_id) if User.exists?(user_id)
    errors = []
    unless bidder.nil?
      errors << "insufficient funds" if bidder.budget < amount
      errors << "auction closed" unless is_active 
      errors << "invalid amount" unless amount > current_price
    else
      errors << "user could not be found"
    end

    if errors.length == 0
      begin
        Auction.transaction do
          best_bidder.return_funds(current_price) unless best_bidder_id.nil?      
          bidder.bid_amount(amount)   
          self.update_attributes(current_price: amount, best_bidder: bidder)
        end
      rescue
        errors << "error bidding for item"
      end
    end

    return errors
  end

  def finish
    self.update_column(:is_active, false)
  end
end
