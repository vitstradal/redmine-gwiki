resources :projects do
  resource  :gwiki_wiki
  get  '/gwiki/*id', to: 'gwiki#show',   constrains: { id: /.*/}, as: 'gwiki_show'
  post '/gwiki/*id', to: 'gwiki#update', constrains: { id: /.*/}, as: 'gwiki_update'
  get  '/gwiki',     to: 'gwiki#index', as: 'gwiki_index'
end
