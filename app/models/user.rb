class User < ActiveRecord::Base
  validates :budget, presence: true, numericality: { only_integer: true }
  validates_uniqueness_of :id
  has_many :items
  has_many :auctions

  def bid_amount(amount)
    decrement!(:budget, amount)
    increment!(:blocked_budget, amount)
  end

  def return_funds(amount)
    increment!(:budget, amount)
    decrement!(:blocked_budget, amount)
  end
end
