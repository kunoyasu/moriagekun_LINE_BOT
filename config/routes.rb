Rails.application.routes.draw do
  post '/callback', to: 'message#callback'
end