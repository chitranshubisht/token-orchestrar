Rails.application.routes.draw do
  resources :keys
  put 'keepalive/:id', to: 'keys#keep_alive'
end
