Rabel::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "sessions", :registrations => "registrations"}
  get 'settings' => 'users#edit'
  get 'member/:nickname' => 'users#show', :as => :member
  get 'member/:nickname/topics' => 'users#topics', :as => :member_topics
  post 'member/:nickname/follow' => 'users#follow', :as => :follow_user
  post 'member/:nickname/unfollow' => 'users#unfollow', :as => :unfollow_user
  put 'users/update_account' => 'users#update_account', :as => :update_account
  put 'users/update_password' => 'users#update_password', :as => :update_password
  put 'users/update_avatar' => 'users#update_avatar', :as => :update_avatar
  get 'go/:key' => 'nodes#show', :as => :go
  get 't/:id' => 'topics#show', :as => :t
  get '/topics/:id' => redirect('/t/%{id}'), :constraints => { :id => /\d+/ }

  get 'my/topics' => 'users#my_topics', :as => :my_topics
  get 'my/following' => 'users#my_following', :as => :my_following
  get 'page/:key' => 'pages#show', :as => :page
  get 'goodbye' => 'welcome#goodbye'
  get 'captcha' => 'welcome#captcha'
  get 'sitemap' => 'welcome#sitemap'

  resources :nodes do
    resources :topics do
      member do
        get :move
        get :edit_title
        put :update_title
      end
    end
  end
  resources :topics do
    resources :comments
    resources :bookmarks
    post :preview, :on => :collection
    put :toggle_comments_closed
    put :toggle_sticky
  end

  resources :comments, :bookmarks, :upyun_images

  resources :notifications do
    get :read, :on => :member
  end

  namespace :admin do
    resources :planes do
      resources :nodes
      post :sort, :on => :collection
      get :sort, :on => :collection
    end

    resources :nodes do
      post :sort, :on => :collection
      get :move, :on => :member
      put :move_to, :on => :member
    end

    resources :users do
      member do
        put :toggle_admin
        put :toggle_blocked
      end
      resources :rewards
    end

    resources :pages do
      post :sort, :on => :collection
    end

    resource :site_settings
    resources :topics, :advertisements, :cloud_files, :rewards
    
    resources :notifications do
      delete :clear, :on => :collection
    end

    get 'appearance' => 'site_settings#appearance'

    root :to => 'welcome_admin#index'
  end
  root :to => 'welcome#index'
end
