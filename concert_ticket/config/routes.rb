Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "/" => "application#landing_page"
  get "login" => "login#index"
  post "login_authenication" => "login#authenicate"
  get "logout" => "login#logout"

  scope "/:locale", constraints: { locale: /en|th/ }  do
    root "concert_info#index"
    get "siam_music_festival" => "application#landing_page"
    post "create_event" => "concert_info#create"
    get "get_default" => "concert_info#get_default"
    post "select_event" => "concert_info#select_event"
    get "get_concert" => "concert_info#get_concert_info"

    get "report" => "dashboard#index"
    get "datatable" => "dashboard#datatables"
    get "dashboard/filter" => "dashboard#filter_company"
    get "dashboard/download_report" => "dashboard#download_report"

    get "qr" => "generate_qrs#index"
    get "get_qr" => "generate_qrs#get_qr"
    post "download_qr" => "generate_qrs#download_qr"
    post "send_mail" => "generate_qrs#send_mail"
    resource :generate_qr

    get "registration" => "registration_users#index"
    get "registration_user/get_others" => "registration_users#get_other_user"
    post "registration_user/send_mail" => "registration_users#send_mail"
    get "registration_user/limit_quota" => "registration_users#limit_quota"
    get "registration_user/:token" => "registration_users#show"
    resource :registration_user
    
    get "scan_qr" => "scan_qr#index"
    get "scan_qr/get_user/:id" => "scan_qr#confirm_participated"

    resource :user
    get "user_datatable" => "users#datatable"
  end
end
