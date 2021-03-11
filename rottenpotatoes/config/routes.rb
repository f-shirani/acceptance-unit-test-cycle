Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  
  get 'search_same_director/:id', to: 'movies#search', as: :search_same_director
end
