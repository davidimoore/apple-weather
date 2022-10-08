class WeatherReporter
  include WeatherService

  class WeatherReporterError < StandardError
    def initialize(msg = "There was an error when fetching the weather report")
      super(msg)
    end
  end

  # 30 minutes
  POSTALCODE_CACHE_EXPIRATION = 1800

  def initialize(address:)
    @address = address
    @result = {
      cached: false,
      current_temperature: nil,
      forecast: nil
    }.with_indifferent_access
  end

  def perform
    begin
      geocoder_result = Geocoder.new(address: @address).perform
      find_or_fetch_weather_report(**geocoder_result)
    rescue Geocoder::GeocoderError => e
      raise WeatherReporterError.new(e.message)
    end

    @result.with_indifferent_access
  end

  private

  def fetch_current_temperature(response)
    properties = response.dig("properties")
    url = properties.dig("observationStations")
    begin
      @result[:current_temperature] = CurrentTemperatureReporter.new(url: url).perform
    rescue CurrentTemperatureReporter::CurrentTemperatureError => e
      raise WeatherReporterError.new(e.message)
    end
  end

  def fetch_forecast_data(response)
    begin
      forecast_url = response.dig("properties", "forecast")
      @result[:forecast] = ForecastReporter.new(forecast_url: forecast_url).perform
    rescue ForecastReporter::ForecastReporterError => e
      raise WeatherReporterError.new(e.message)
    end
  end

  def fetch_weather_data(postal_code:, lat:, long:)
    response = request("#{BASE_URL}/points/#{lat},#{long}")
    raise WeatherReporterError.new if response.nil?

    fetch_current_temperature(response)
    fetch_forecast_data(response)

    $redis.set(
      cache_key(postal_code),
      { **@result, cached: true }.to_json,
      ex: POSTALCODE_CACHE_EXPIRATION
    )
  end

  def find_or_fetch_weather_report(postal_code:, longitude:, latitude:)
    cached_result = $redis.get(cache_key(postal_code))

    if cached_result.present?
      @result = JSON.parse(cached_result).with_indifferent_access
    else
      fetch_weather_data(postal_code: postal_code, lat: latitude, long: longitude)
    end

    @result
  end

  def cache_key(postal_code)
    "#{ENV["RAILS_ENV"]}-#{postal_code}"
  end
end