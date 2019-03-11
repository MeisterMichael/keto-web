Rails.application.routes.draw do
	# default_url_options :host => Pulitzer.app_host

	root to: 'root#index' # homepage

	resources :admin


	scope module: 'dewey' do
	  resources :enrollment_course_pages do
			get :next, on: :collection
		end
	end

	resources :foods, path: '/nutrition_facts'

	resources :ingredient_admin

	resources :inspiration_admin do
		get :preview, on: :member
	end

	get '/how', to: redirect( 'https://docs.google.com/document/d/13QIT3wQZKmNjCg9sIfYmOGwfDSiL7nvBdgoyicmArlM/edit' )

	resources :recipes
	get '/:tagged_path/recipes' => 'recipes#index', as: 'tagged_recipes'
	resources :recipe_admin do
		get :preview, on: :member
	end

	resources :search, only: [:index]

	resources :usda_food_admin

	devise_scope :user do
		get '/forgot' => 'passwords#new', as: 'forgot'
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		get '/register' => 'registrations#new', as: 'register'
	end
	devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions', :passwords => 'passwords' }

	resources :users, path: User.mounted_path

	mount SwellId::Engine, at: '/'
	mount Pulitzer::Engine, at: '/'
	mount Scuttlebutt::Engine, :at => '/'
	mount Socratic::Engine, :at => '/'
	mount Bunyan::Engine, :at => '/'
	mount Edison::Engine, :at => '/'
	mount Bazaar::Engine, :at => '/'
	mount Dewey::Engine, :at => '/'
	# mount Franklin::Engine, :at => '/'

	resources :bazaar_media_admin do
		get :preview, on: :member
		delete :empty_trash, on: :collection
	end

	resources :bazaar_media, only: [:show, :index], path: BazaarMedia.mounted_path

	get '/about' => 'root#about', as: 'about'
	get '/faq' => 'root#faq', as: 'faq'

	# quick catch-all route for static pages set root route to field any media
	get '/:id', to: 'root#show', as: 'root_show'
end
