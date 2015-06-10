class User < ActiveRecord::Base
  validates :budget, presence: true, numericality: { only_integer: true }
  validates_uniqueness_of :id
  has_many :items, dependent: :destroy
  has_many :auctions, dependent: :destroy

  def bid_amount(amount)
    begin
      User.transaction do
        decrement!(:budget, amount)
        increment!(:blocked_budget, amount)
      end   
    rescue
      raise "error bidding amount"
    end
  end

  def return_funds(amount)
    begin
      User.transaction do
        increment!(:budget, amount)
        decrement!(:blocked_budget, amount)
      end
    rescue
      raise "error returning amount"
    end
  end

  def owned_item_ids
    item_ids
  end
end
