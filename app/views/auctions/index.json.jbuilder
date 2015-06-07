json.result "success"
json.data do 
  json.auctions @auctions.each do |auction|
    json.id auction.item_id
    json.userId auction.user_id
    json.isActive auction.is_active
    json.bestBidderId auction.best_bidder_id
    json.currentPrice auction.current_price
  end

  json.users @users.each do |user|
    json.id user.id
    json.budget user.budget
    json.blockedBudget user.blocked_budget || 0
    json.ownedItemIds user.owned_item_ids 
  end
end