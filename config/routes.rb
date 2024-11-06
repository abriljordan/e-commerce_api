Rails.application.routes.draw do
post '/signup', to: 'authentication#signup'
post '/login', to: 'authentication#login'
get '/protected_endpoint', to: 'protected#show'

end
