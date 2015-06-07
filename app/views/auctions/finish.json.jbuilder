json.result "success"
json.data do 
  json.winnerId @auction.best_bidder_id
  json.price @auction.current_price
end