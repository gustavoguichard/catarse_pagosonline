CatarsePagosonline::Engine.routes.draw do
  namespace :payment do
    get '/pagosonline/:id/review' => 'pagosonline#review', :as => 'review_pagosonline'
    post '/pagosonline/notifications' => 'pagosonline#ipn',  :as => 'ipn_pagosonline'
    match '/pagosonline/:id/notifications' => 'pagosonline#notifications',  :as => 'notifications_pagosonline'
    match '/pagosonline/:id/success'       => 'pagosonline#success',        :as => 'success_pagosonline'
    match '/pagosonline/:id/cancel'        => 'pagosonline#cancel',         :as => 'cancel_pagosonline'
  end
end
