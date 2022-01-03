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
    get '/admin' => 'admin/homes#top'
end
