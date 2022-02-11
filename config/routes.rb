Rails.application.routes.draw do
  post '/callback', to: 'messages#callback'
end