Rails.application.routes.draw do
  root "weather_report#index"
  get "weather_reports", to: "weather_report#index"
end
