CatarsePagosonline::Engine.routes.draw do
  namespace :payment do
    resources :pagosonline, only: [] do
      member do
        get :pay
        get :review
        get :success
        get :error
      end

      collection do
        post :notifications
      end
    end
  end
end
