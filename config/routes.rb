Cycling::Application.routes.draw do

  root to: 'stories#index'

  resources :stories
  
  resources :features do
    collection do
      get 'query'
    end
  end
  
end
