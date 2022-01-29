Rails.application.routes.draw do
  post '/callback', to: 'dices#callback'
end