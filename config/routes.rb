Smithy::Engine.routes.draw do
  root :to => 'pages#show'
  scope "/smithy" do
    # CMS admin
    resources :assets
    resources :content_blocks
    resources :guides, :only => :show
    resources :pages do
      collection do
        get :order
      end
      resources :contents, :controller => "PageContents", :except => [ :index ] do
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

    # Content Blocks
    resources :contents, :except => :index
    resources :images, :except => :index
  end
  match '/templates/javascripts/*javascript' => 'templates#javascript', :defaults => { :format => 'js' }
  match '/templates/stylesheets/*stylesheet' => 'templates#stylesheet', :format => 'css'
  match '*path' => 'pages#show'
end
