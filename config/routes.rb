Rails.application.routes.draw do

  devise_for :admins, controllers: {
      sessions: 'admins/sessions',
      passwords: 'admins/passwords',
      registrations: 'admins/registrations'
  }

  devise_for :customers, controllers: {
      sessions: 'customers/sessions',
      passwords: 'customers/passwords',
      registrations: 'customers/registrations'
  }

    root :to => 'public/homes#top'
    get '/about' => 'public/homes#about'
    get '/admin' => 'admin/homes#top'

    namespace :admin do
      resources :genres
      resources :items, only:[:new, :create, :index, :show, :edit, :update]
      resources :customers, only:[:index, :show, :edit, :update]
      resources :orders, only:[:show, :update]
      resources :order_details, only:[:update]
    end

    scope module: :public do
      resources :items, only:[:index, :show]
      resources :customers, only:[:show, :edit, :update] do
        collection do
          get 'quit'
        end
        collection do
          patch 'out'
        end
      end
      resources :cart_items, only:[:index, :update, :destroy, :create] do
        collection do
          delete 'destroy_all'
        end
      end
      post 'orders/log', to: 'orders#log'
      resources :orders, only:[:new, :create, :index, :show] do
        collection do
          get 'thanks'
        end
      end
      resources :shipping_addresses, only:[:index, :edit, :create, :update, :destroy]
    end

end
