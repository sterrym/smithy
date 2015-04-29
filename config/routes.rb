Smithy::Engine.routes.draw do
  root :to => 'pages#show'
  scope "/smithy" do
    get '/' => redirect('/smithy/pages')
    get '/login'  => redirect('/'), :as => :login unless has_named_route?(:login)
    delete '/logout' => redirect('/'), :as => :logout unless has_named_route?(:logout)
    # CMS admin
    resources :assets do
      collection do
        get :presigned_fields
      end
    end
    resources :content_blocks
    resources :guides, :only => :show
    resources :pages do
      collection do
        get :order
      end
      resources :contents, :controller => "page_contents", :except => [ :index ] do
        member do
          get :preview
        end
        collection do
          get :order
        end
      end
    end
    resources :templates
    resources :settings
    resource :cache

    # Content Pieces
    # scope "/content_pieces" do
    #   # ie. /smithy/content_pieces/locations/1/edit
    # end
  end
  # Sitemap
  resource :sitemap, :controller => "sitemap", :only => [ :show ]
  get '/assets/*id' => 'assets#data'
  get '/templates/javascripts/*javascript' => 'templates#javascript', :defaults => { :format => 'js' }
  get '/templates/stylesheets/*stylesheet' => 'templates#stylesheet', :format => 'css'
  get '*path' => 'pages#show'
end
