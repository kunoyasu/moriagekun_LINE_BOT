Rails.application.routes.draw do
  post '/callback', to: 'englishes#callback'
end