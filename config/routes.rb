Cycling::Application.routes.draw do

  root to: 'stories#index'

  namespace :api do
    resources :stories do
      collection do
        post 'search'
      end
    end
  end

  resources :stories do
    collection do
      get 'export'
    end
  end
  
  resources :features do
    collection do
      get 'query'
    end
  end
  
  resources :dashboards do
    collection do
      get 'cycles'
      get 'completed'
      get 'in_progress'
    end
  end
  
  resources :developers do
    collection do
      get 'query'
    end
  end
  
end
