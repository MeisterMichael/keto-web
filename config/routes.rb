Rails.application.routes.draw do
	# default_url_options :host => Pulitzer.app_host

	root to: 'root#index' # homepage

	resources :admin

	resources :inspiration_admin do
		get :preview, on: :member
	end

	resources :recipes
	resources :recipe_admin do
		get :preview, on: :member
	end

	devise_scope :user do
		get '/login' => 'sessions#new', as: 'login'
		get '/logout' => 'sessions#destroy', as: 'logout'
		get '/register' => 'registrations#new', as: 'register'
	end
	devise_for :users, :controllers => { :registrations => 'registrations', :sessions => 'sessions' }


	mount SwellId::Engine, at: '/'
	mount Pulitzer::Engine, at: '/'
	mount Scuttlebutt::Engine, :at => '/'
	mount Socratic::Engine, :at => '/'
	mount Bunyan::Engine, :at => '/'
	mount Edison::Engine, :at => '/'
	# mount Bazaar::Engine, :at => '/'

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
