class WeatherReportController < ApplicationController
  def index
    if params["query"].present?
      begin
        @weather_report = WeatherReporter.new(address: params["query"]).perform

        if turbo_frame_request?
          render partial: "weather_report", locals: { bands: @weather_report }
        else
          render :index
        end

      rescue WeatherReporter::WeatherReporterError => e
        flash.now.alert = e
        render :index
      end
    end
  end
end

