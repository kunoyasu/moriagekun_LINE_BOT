Rails.application.routes.draw do
  post '/callback', to: 'gayas#callback'
end