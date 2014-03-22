resources :projects do
  resource  :wigi_wiki
  get  '/wigi/*id', to: 'wigi#show',   constrains: { id: /.*/}, as: 'wigi_show'
  post '/wigi/*id', to: 'wigi#update', constrains: { id: /.*/}, as: 'wigi_update'
  get  '/wigi',     to: 'wigi#index', as: 'wigi_index'
end
