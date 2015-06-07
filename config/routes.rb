Rails.application.routes.draw do
  post 'add_user' => 'users#create'
  post 'add_item' => 'items#create'
  get 'snapshot' => 'auctions#index', as: :snapshot
  put 'bid' => 'auctions#bid', as: :bid
  put 'finish' => 'auctions#finish', as: :finish
end