class ForecastReporter
  include WeatherService

  class ForecastReporterError < StandardError
    def initialize(msg="There was an error when fetching the forecast")
      super(msg)
    end
  end

  def initialize(forecast_url:)
    @url = forecast_url
  end

  def perform
    begin
      forecast_url_response = request(@url)
    rescue StandardError
      raise ForecastReporterError.new
    end

    periods = forecast_url_response&.dig("properties", "periods")

    if periods.present?
      periods.map do |period|
        {
          day: period.dig("name"),
          date: period.dig("startTime")&.to_datetime&.strftime("%m/%d"),
          icon: period.dig("icon"),
          temperature: period.dig("temperature"),
          detailed_forecast: period.dig("detailedForecast")
        }
      end
    else
      raise ForecastReporterError.new
    end
  end
end
