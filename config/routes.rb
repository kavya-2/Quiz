Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # get '/all_students/:quiz_type', to: 'students#all_students'
  # get '/subject_performance/:subject', to: 'students#subject_performance'
  # get '/class_information', to: 'students#class_information'

  get '/all_students/:quiz_type/(:page)', to: 'all_students#index'
  get '/subject_performance', to: 'subject_performance#index'
  get '/class_information', to: 'class_information#index'
end
