class Auction < ActiveRecord::Base
  belongs_to :item
  belongs_to :user

  validates :item_id, :user_id, :current_price, presence: true, numericality: { only_integer: true }

  def bid(user_id, item_id, amount)
    amount = amount.to_i
    user = User.find(user_id)
    last_best_bidder = User.find(best_bidder_id) unless best_bidder_id.nil?
    errors = []
    errors << "insufficient funds" if user.budget < amount
    errors << "auction closed" unless is_active 
    errors << "invalid amount" unless amount > current_price

    if errors.length == 0
      last_best_bidder.return_funds(current_price) unless best_bidder_id.nil?
      self.current_price = amount 
      self.best_bidder_id = user_id
      user.bid_amount(amount)      
      self.save!
    end

    return errors
  end

  def finish
    self.is_active = false
    self.save!
  end
end
